import { SupabaseClient } from '@supabase/supabase-js';
import {
  NotFoundError,
  InternalError,
  ConflictError,
  ValidationError,
  ForbiddenError,
} from '../../lib/errors';
import type {
  PhoneJail,
  JailSessionWithProgress,
  StartJailInput,
  HeartbeatInput,
  BreakJailInput,
  JailCompletion,
} from './types';
import {
  calculateSessionProgress,
  shouldAutoComplete,
  shouldPauseSession,
  calculatePauseDuration,
  validateBlockedApps,
  calculateBreakFineAmount,
} from './utils';

/**
 * Start a new jail session
 */
export async function startJailSession(
  supabase: SupabaseClient,
  userId: string,
  input: StartJailInput
): Promise<PhoneJail> {
  // Validate blocked apps
  const appValidation = validateBlockedApps(input.blocked_apps);
  if (!appValidation.valid) {
    throw new ValidationError(appValidation.reason || 'Invalid blocked apps');
  }

  // Get goal details
  const { data: goal } = await supabase
    .from('goals')
    .select('pack_id, jail_duration, title')
    .eq('id', input.goal_id)
    .single();

  if (!goal) {
    throw new NotFoundError('Goal');
  }

  // Check if user already has an active jail session
  const { data: activeSession } = await supabase
    .from('phone_jails')
    .select('id')
    .eq('user_id', userId)
    .eq('status', 'active')
    .single();

  if (activeSession) {
    throw new ConflictError('You already have an active jail session');
  }

  // Determine duration (use goal default if not provided)
  const durationMinutes = input.duration_minutes || goal.jail_duration || 30;

  // Create jail session
  const { data: jailSession, error } = await supabase
    .from('phone_jails')
    .insert({
      user_id: userId,
      pack_id: goal.pack_id,
      goal_id: input.goal_id,
      fine_id: input.fine_id,
      duration_minutes: durationMinutes,
      blocked_apps: input.blocked_apps,
      status: 'active',
      started_at: new Date().toISOString(),
      last_heartbeat_at: new Date().toISOString(),
      total_paused_duration: 0,
    })
    .select(
      '*, user:users(username, profile_pic), goal:goals(title)'
    )
    .single();

  if (error || !jailSession) {
    console.error('Jail session creation error:', error);
    throw new InternalError('Failed to start jail session');
  }

  return {
    ...jailSession,
    user: jailSession.user,
    goal: jailSession.goal,
  } as PhoneJail;
}

/**
 * Send heartbeat to keep session active
 */
export async function sendHeartbeat(
  supabase: SupabaseClient,
  jailId: string,
  userId: string,
  input: HeartbeatInput
): Promise<JailSessionWithProgress> {
  // Get session
  const { data: session } = await supabase
    .from('phone_jails')
    .select('*')
    .eq('id', jailId)
    .single();

  if (!session) {
    throw new NotFoundError('Jail session');
  }

  // Verify ownership
  if (session.user_id !== userId) {
    throw new ForbiddenError('This is not your jail session');
  }

  // Can only heartbeat active sessions
  if (session.status !== 'active') {
    throw new ValidationError('Jail session is not active');
  }

  const now = new Date();

  // Check if session should be auto-completed
  if (shouldAutoComplete(session, now)) {
    return await completeJailSession(supabase, jailId);
  }

  // If session was paused, resume it and add pause duration
  let updates: any = {
    last_heartbeat_at: now.toISOString(),
    updated_at: now.toISOString(),
  };

  if (session.paused_at) {
    const pauseDuration = calculatePauseDuration(session.paused_at, now);
    updates.total_paused_duration = session.total_paused_duration + pauseDuration;
    updates.paused_at = null; // Resume
  }

  // Update session
  const { data: updatedSession, error } = await supabase
    .from('phone_jails')
    .update(updates)
    .eq('id', jailId)
    .select(
      '*, user:users(username, profile_pic), goal:goals(title)'
    )
    .single();

  if (error || !updatedSession) {
    console.error('Heartbeat update error:', error);
    throw new InternalError('Failed to update heartbeat');
  }

  return calculateSessionProgress({
    ...updatedSession,
    user: updatedSession.user,
    goal: updatedSession.goal,
  } as PhoneJail);
}

/**
 * Break jail early (pay 2x fine)
 */
export async function breakJailEarly(
  supabase: SupabaseClient,
  jailId: string,
  userId: string,
  input: BreakJailInput
): Promise<PhoneJail> {
  // Get session
  const { data: session } = await supabase
    .from('phone_jails')
    .select('*, goal:goals(fine_amount, packs(default_fine_amount))')
    .eq('id', jailId)
    .single();

  if (!session) {
    throw new NotFoundError('Jail session');
  }

  // Verify ownership
  if (session.user_id !== userId) {
    throw new ForbiddenError('This is not your jail session');
  }

  // Can only break active sessions
  if (session.status !== 'active') {
    throw new ValidationError('Jail session is not active');
  }

  // Calculate break fine amount (2x original)
  const originalFineAmount =
    ((session.goal as any)?.fine_amount ||
      (session.goal as any)?.packs?.default_fine_amount ||
      5) * 100; // Convert to cents
  const breakFineAmount = calculateBreakFineAmount(originalFineAmount);

  // Create punishment for 2x fine
  const { data: punishment, error: punishmentError } = await supabase
    .from('punishments')
    .insert({
      user_id: userId,
      pack_id: session.pack_id,
      fine_id: session.fine_id,
      type: 'fine',
      amount: breakFineAmount,
      status: 'pending',
    })
    .select()
    .single();

  if (punishmentError) {
    console.error('Break jail punishment error:', punishmentError);
    throw new InternalError('Failed to create punishment');
  }

  // Create transaction placeholder
  await supabase.from('transactions').insert({
    user_id: userId,
    punishment_id: punishment.id,
    amount: breakFineAmount,
    status: 'pending',
    payment_method: input.payment_method,
  });

  // Mark session as broken
  const { data: brokenSession, error } = await supabase
    .from('phone_jails')
    .update({
      status: 'broken',
      completed_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    })
    .eq('id', jailId)
    .select(
      '*, user:users(username, profile_pic), goal:goals(title)'
    )
    .single();

  if (error || !brokenSession) {
    console.error('Break jail update error:', error);
    throw new InternalError('Failed to break jail session');
  }

  return {
    ...brokenSession,
    user: brokenSession.user,
    goal: brokenSession.goal,
  } as PhoneJail;
}

/**
 * Get jail session with progress
 */
export async function getJailSession(
  supabase: SupabaseClient,
  jailId: string
): Promise<JailSessionWithProgress> {
  const { data: session, error } = await supabase
    .from('phone_jails')
    .select(
      '*, user:users(username, profile_pic), goal:goals(title)'
    )
    .eq('id', jailId)
    .single();

  if (error || !session) {
    throw new NotFoundError('Jail session');
  }

  const jailSession = {
    ...session,
    user: session.user,
    goal: session.goal,
  } as PhoneJail;

  // Auto-complete if needed
  if (shouldAutoComplete(jailSession)) {
    return await completeJailSession(supabase, jailId);
  }

  // Check if should be paused
  if (
    jailSession.status === 'active' &&
    jailSession.last_heartbeat_at &&
    !jailSession.paused_at &&
    shouldPauseSession(jailSession.last_heartbeat_at)
  ) {
    // Pause the session
    await supabase
      .from('phone_jails')
      .update({
        paused_at: new Date().toISOString(),
      })
      .eq('id', jailId);

    jailSession.paused_at = new Date().toISOString();
  }

  return calculateSessionProgress(jailSession);
}

/**
 * Get active jail sessions for user
 */
export async function getActiveJailSessions(
  supabase: SupabaseClient,
  userId: string
): Promise<JailSessionWithProgress[]> {
  const { data: sessions, error } = await supabase
    .from('phone_jails')
    .select(
      '*, user:users(username, profile_pic), goal:goals(title)'
    )
    .eq('user_id', userId)
    .eq('status', 'active')
    .order('started_at', { ascending: false });

  if (error) {
    console.error('Active sessions fetch error:', error);
    return [];
  }

  return (sessions || []).map((session) =>
    calculateSessionProgress({
      ...session,
      user: session.user,
      goal: session.goal,
    } as PhoneJail)
  );
}

/**
 * Complete jail session
 */
async function completeJailSession(
  supabase: SupabaseClient,
  jailId: string
): Promise<JailSessionWithProgress> {
  const { data: session } = await supabase
    .from('phone_jails')
    .select('*')
    .eq('id', jailId)
    .single();

  if (!session) {
    throw new NotFoundError('Jail session');
  }

  // Mark as completed
  const { data: completedSession, error } = await supabase
    .from('phone_jails')
    .update({
      status: 'completed',
      completed_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    })
    .eq('id', jailId)
    .select(
      '*, user:users(username, profile_pic), goal:goals(title)'
    )
    .single();

  if (error || !completedSession) {
    console.error('Complete jail error:', error);
    throw new InternalError('Failed to complete jail session');
  }

  // Generate feed event
  await supabase.from('feed_events').insert({
    user_id: session.user_id,
    pack_id: session.pack_id,
    type: 'jail_served',
    reference_id: jailId,
    metadata: {
      duration_minutes: session.duration_minutes,
      goal_id: session.goal_id,
    },
  });

  // If associated with a fine, mark punishment as served
  if (session.fine_id) {
    await supabase
      .from('punishments')
      .update({ status: 'served' })
      .eq('fine_id', session.fine_id)
      .eq('type', 'jail');
  }

  return calculateSessionProgress({
    ...completedSession,
    user: completedSession.user,
    goal: completedSession.goal,
  } as PhoneJail);
}
