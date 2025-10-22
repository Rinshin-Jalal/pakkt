import { SupabaseClient } from '@supabase/supabase-js';
import {
  NotFoundError,
  InternalError,
  ForbiddenError,
} from '../../lib/errors';
import type { Goal, CreateGoalInput, UpdateGoalInput, GoalWithStats } from './types';

/**
 * Create a new goal for a pack
 */
export async function createGoal(
  supabase: SupabaseClient,
  packId: string,
  userId: string,
  input: CreateGoalInput
): Promise<Goal> {
  // Get pack defaults if not provided
  const { data: pack } = await supabase
    .from('packs')
    .select('default_fine_amount, default_jail_duration')
    .eq('id', packId)
    .single();

  const { data: goal, error } = await supabase
    .from('goals')
    .insert({
      pack_id: packId,
      user_id: userId,
      title: input.title,
      description: input.description,
      check_in_time: input.check_in_time,
      recurrence_rule: input.recurrence_rule,
      fine_amount: input.fine_amount ?? pack?.default_fine_amount ?? 5,
      jail_duration: input.jail_duration ?? pack?.default_jail_duration ?? 30,
      proof_required: input.proof_required ?? false,
      base_xp: input.base_xp ?? 100,
      is_active: true,
    })
    .select('*, users:user_id(username, display_name, avatar_url)')
    .single();

  if (error || !goal) {
    console.error('Goal creation error:', error);
    throw new InternalError('Failed to create goal');
  }

  return {
    ...goal,
    user: goal.users,
  } as Goal;
}

/**
 * List goals for a pack with optional filters
 */
export async function listPackGoals(
  supabase: SupabaseClient,
  packId: string,
  filters?: {
    is_active?: boolean;
    user_id?: string;
  }
): Promise<Goal[]> {
  let query = supabase
    .from('goals')
    .select('*, users:user_id(username, display_name, avatar_url)')
    .eq('pack_id', packId)
    .order('created_at', { ascending: false });

  if (filters?.is_active !== undefined) {
    query = query.eq('is_active', filters.is_active);
  }

  if (filters?.user_id) {
    query = query.eq('user_id', filters.user_id);
  }

  const { data: goals, error } = await query;

  if (error) {
    console.error('Goals list error:', error);
    throw new InternalError('Failed to list goals');
  }

  return (goals || []).map((goal) => ({
    ...goal,
    user: goal.users,
  })) as Goal[];
}

/**
 * Get a specific goal by ID
 */
export async function getGoal(
  supabase: SupabaseClient,
  goalId: string
): Promise<Goal> {
  const { data: goal, error } = await supabase
    .from('goals')
    .select('*, users:user_id(username, display_name, avatar_url)')
    .eq('id', goalId)
    .single();

  if (error || !goal) {
    throw new NotFoundError('Goal');
  }

  return {
    ...goal,
    user: goal.users,
  } as Goal;
}

/**
 * Update a goal
 */
export async function updateGoal(
  supabase: SupabaseClient,
  goalId: string,
  userId: string,
  updates: UpdateGoalInput
): Promise<Goal> {
  // Verify goal ownership
  const goal = await getGoal(supabase, goalId);
  
  if (goal.user_id !== userId) {
    throw new ForbiddenError('You can only update your own goals');
  }

  const { data: updatedGoal, error } = await supabase
    .from('goals')
    .update({
      ...updates,
      updated_at: new Date().toISOString(),
    })
    .eq('id', goalId)
    .select('*, users:user_id(username, display_name, avatar_url)')
    .single();

  if (error || !updatedGoal) {
    console.error('Goal update error:', error);
    throw new InternalError('Failed to update goal');
  }

  return {
    ...updatedGoal,
    user: updatedGoal.users,
  } as Goal;
}

/**
 * Delete a goal
 */
export async function deleteGoal(
  supabase: SupabaseClient,
  goalId: string,
  userId: string
): Promise<void> {
  // Verify goal ownership
  const goal = await getGoal(supabase, goalId);
  
  if (goal.user_id !== userId) {
    throw new ForbiddenError('You can only delete your own goals');
  }

  // Check if there are any check-ins for this goal
  const { count } = await supabase
    .from('check_ins')
    .select('*', { count: 'exact', head: true })
    .eq('goal_id', goalId);

  if (count && count > 0) {
    // Don't actually delete, just deactivate
    await supabase
      .from('goals')
      .update({ is_active: false })
      .eq('id', goalId);
  } else {
    // No check-ins, safe to delete
    const { error } = await supabase
      .from('goals')
      .delete()
      .eq('id', goalId);

    if (error) {
      console.error('Goal deletion error:', error);
      throw new InternalError('Failed to delete goal');
    }
  }
}

/**
 * Toggle goal active status
 */
export async function toggleGoalStatus(
  supabase: SupabaseClient,
  goalId: string,
  userId: string
): Promise<Goal> {
  // Verify goal ownership
  const goal = await getGoal(supabase, goalId);
  
  if (goal.user_id !== userId) {
    throw new ForbiddenError('You can only toggle your own goals');
  }

  const { data: updatedGoal, error } = await supabase
    .from('goals')
    .update({
      is_active: !goal.is_active,
      updated_at: new Date().toISOString(),
    })
    .eq('id', goalId)
    .select('*, users:user_id(username, display_name, avatar_url)')
    .single();

  if (error || !updatedGoal) {
    console.error('Goal toggle error:', error);
    throw new InternalError('Failed to toggle goal status');
  }

  return {
    ...updatedGoal,
    user: updatedGoal.users,
  } as Goal;
}

/**
 * Get goal with statistics
 */
export async function getGoalWithStats(
  supabase: SupabaseClient,
  goalId: string
): Promise<GoalWithStats> {
  const goal = await getGoal(supabase, goalId);

  // Get check-ins count
  const { count: totalCheckins } = await supabase
    .from('check_ins')
    .select('*', { count: 'exact', head: true })
    .eq('goal_id', goalId);

  // Get streak information (simplified - would need more complex logic for actual streak)
  const { data: recentCheckins } = await supabase
    .from('check_ins')
    .select('created_at')
    .eq('goal_id', goalId)
    .order('created_at', { ascending: false })
    .limit(30);

  // Calculate completion rate (simplified)
  const daysSinceCreation = Math.floor(
    (Date.now() - new Date(goal.created_at).getTime()) / (1000 * 60 * 60 * 24)
  );
  const expectedCheckins = Math.max(1, daysSinceCreation);
  const completionRate = Math.min(
    100,
    Math.round(((totalCheckins || 0) / expectedCheckins) * 100)
  );

  // Calculate streaks (simplified)
  let currentStreak = 0;
  let longestStreak = 0;
  
  if (recentCheckins && recentCheckins.length > 0) {
    // Simple calculation - would need more complex logic for actual streaks
    currentStreak = recentCheckins.length >= 7 ? 7 : recentCheckins.length;
    longestStreak = recentCheckins.length;
  }

  return {
    ...goal,
    total_checkins: totalCheckins || 0,
    completion_rate: completionRate,
    current_streak: currentStreak,
    longest_streak: longestStreak,
  };
}

/**
 * Get all active goals for a user across all packs
 */
export async function getUserActiveGoals(
  supabase: SupabaseClient,
  userId: string
): Promise<Goal[]> {
  // Get user's pack IDs
  const { data: memberships } = await supabase
    .from('pack_members')
    .select('pack_id')
    .eq('user_id', userId);

  if (!memberships || memberships.length === 0) {
    return [];
  }

  const packIds = memberships.map((m) => m.pack_id);

  const { data: goals, error } = await supabase
    .from('goals')
    .select('*, users:user_id(username, display_name, avatar_url)')
    .in('pack_id', packIds)
    .eq('is_active', true)
    .order('check_in_time', { ascending: true });

  if (error) {
    console.error('User goals fetch error:', error);
    return [];
  }

  return (goals || []).map((goal) => ({
    ...goal,
    user: goal.users,
  })) as Goal[];
}
