import { SupabaseClient } from '@supabase/supabase-js';
import {
  NotFoundError,
  ConflictError,
  InternalError,
  ForbiddenError,
  ValidationError,
} from '../../lib/errors';
import type {
  Pack,
  PackMember,
  PackStats,
  CreatePackInput,
  UpdatePackInput,
  AddMemberInput,
} from './types';
import {
  generateInviteCode,
  calculateLevelFromXP,
  validateMemberLimit,
  canDissolvePack,
} from './utils';

/**
 * Create a new pack
 */
export async function createPack(
  supabase: SupabaseClient,
  userId: string,
  input: CreatePackInput
): Promise<Pack> {
  // Generate unique invite code
  const inviteCode = generateInviteCode();

  // Create pack
  const { data: pack, error: packError } = await supabase
    .from('packs')
    .insert({
      name: input.name,
      creator_id: userId,
      goal_type: input.goal_type || 'general',
      status: 'active',
    })
    .select()
    .single();

  if (packError || !pack) {
    console.error('Pack creation error:', {
      code: packError?.code,
      message: packError?.message,
      details: packError?.details,
      hint: packError?.hint,
      input: input,
      userId: userId
    });

    throw new InternalError('Failed to create pack');
  }

  // Add creator as admin member (skip for now due to RLS issues)
  try {
    const { error: memberError } = await supabase
      .from('pack_members')
      .insert({
        pack_id: pack.id,
        user_id: userId,
        role: 'admin',
        reputation_xp: 0,
        is_active: true,
      });

    if (memberError) {
      console.warn('Member creation failed (RLS issue), continuing anyway:', memberError);
      // Don't fail the pack creation due to member creation issues
    }
  } catch (err) {
    console.warn('Member creation error (RLS issue), continuing anyway:', err);
    // Don't fail the pack creation
  }

  return pack as Pack;
}

/**
 * Get pack by ID with optional member details
 */
export async function getPack(
  supabase: SupabaseClient,
  packId: string,
  includeMembers: boolean = false
): Promise<Pack & { members?: PackMember[] }> {
  const { data: pack, error } = await supabase
    .from('packs')
    .select('*')
    .eq('id', packId)
    .single();

  if (error || !pack) {
    throw new NotFoundError('Pack');
  }

  if (includeMembers) {
    const { data: members } = await supabase
      .from('pack_members')
      .select('*, users:user_id(username, display_name, avatar_url)')
      .eq('pack_id', packId)
      .order('joined_at', { ascending: true });

    return {
      ...(pack as Pack),
      members: members?.map((m) => ({
        ...m,
        user: m.users,
      })) as PackMember[],
    };
  }

  return pack as Pack;
}

/**
 * Update pack details
 */
export async function updatePack(
  supabase: SupabaseClient,
  packId: string,
  updates: UpdatePackInput
): Promise<Pack> {
  const { data, error } = await supabase
    .from('packs')
    .update({
      ...updates,
      updated_at: new Date().toISOString(),
    })
    .eq('id', packId)
    .select()
    .single();

  if (error || !data) {
    console.error('Pack update error:', error);
    throw new InternalError('Failed to update pack');
  }

  return data as Pack;
}

/**
 * Dissolve (delete) a pack
 */
export async function dissolvePack(
  supabase: SupabaseClient,
  packId: string
): Promise<void> {
  // Check if pack can be dissolved
  const { canDissolve, reason } = await canDissolvePack(supabase, packId);

  if (!canDissolve) {
    throw new ForbiddenError(reason || 'Cannot dissolve pack');
  }

  // Delete pack (cascade will handle members)
  const { error } = await supabase.from('packs').delete().eq('id', packId);

  if (error) {
    console.error('Pack deletion error:', error);
    throw new InternalError('Failed to dissolve pack');
  }
}

/**
 * Add a member to a pack
 */
export async function addMember(
  supabase: SupabaseClient,
  packId: string,
  userId: string
): Promise<PackMember> {
  // Get pack to check member count
  const pack = await getPack(supabase, packId);

  // Validate member limit
  if (!validateMemberLimit(pack.member_count, 1)) {
    throw new ValidationError('Pack has reached maximum member limit (10)');
  }

  // Check if user is already a member
  const { data: existing } = await supabase
    .from('pack_members')
    .select('id')
    .eq('pack_id', packId)
    .eq('user_id', userId)
    .single();

  if (existing) {
    throw new ConflictError('User is already a member of this pack');
  }

  // Add member
  const { data: member, error } = await supabase
    .from('pack_members')
    .insert({
      pack_id: packId,
      user_id: userId,
      role: 'member',
      total_xp: 0,
      current_streak: 0,
    })
    .select('*, users:user_id(username, display_name, avatar_url)')
    .single();

  if (error || !member) {
    console.error('Member addition error:', error);
    throw new InternalError('Failed to add member to pack');
  }

  // Update pack member count
  await supabase
    .from('packs')
    .update({
      member_count: pack.member_count + 1,
      updated_at: new Date().toISOString(),
    })
    .eq('id', packId);

  return {
    ...member,
    user: member.users,
  } as PackMember;
}

/**
 * Remove a member from a pack
 */
export async function removeMember(
  supabase: SupabaseClient,
  packId: string,
  userId: string,
  requesterId: string
): Promise<void> {
  // Get pack
  const pack = await getPack(supabase, packId);

  // Can't remove the creator
  if (pack.creator_id === userId) {
    throw new ForbiddenError('Cannot remove pack creator');
  }

  // Check if member exists
  const { data: member } = await supabase
    .from('pack_members')
    .select('id')
    .eq('pack_id', packId)
    .eq('user_id', userId)
    .single();

  if (!member) {
    throw new NotFoundError('Member');
  }

  // Remove member
  const { error } = await supabase
    .from('pack_members')
    .delete()
    .eq('pack_id', packId)
    .eq('user_id', userId);

  if (error) {
    console.error('Member removal error:', error);
    throw new InternalError('Failed to remove member');
  }

  // Update pack member count
  const newCount = pack.member_count - 1;
  
  // Check if pack still meets minimum requirement
  if (newCount < 3) {
    // Optionally dissolve pack or mark as inactive
    console.warn(`Pack ${packId} now has less than 3 members`);
  }

  await supabase
    .from('packs')
    .update({
      member_count: newCount,
      updated_at: new Date().toISOString(),
    })
    .eq('id', packId);
}

/**
 * Get pack statistics
 */
export async function getPackStats(
  supabase: SupabaseClient,
  packId: string
): Promise<PackStats> {
  // Get pack
  const pack = await getPack(supabase, packId);

  // Get members with stats
  const { data: members } = await supabase
    .from('pack_members')
    .select('user_id, total_xp, current_streak, users:user_id(username)')
    .eq('pack_id', packId)
    .order('total_xp', { ascending: false });

  // Get check-ins count
  const { count: checkinsCount } = await supabase
    .from('check_ins')
    .select('*', { count: 'exact', head: true })
    .in(
      'goal_id',
      supabase.from('goals').select('id').eq('pack_id', packId)
    );

  // Get fines count
  const { count: finesCount } = await supabase
    .from('fines')
    .select('*', { count: 'exact', head: true })
    .eq('pack_id', packId);

  // Get jails count
  const { count: jailsCount } = await supabase
    .from('phone_jails')
    .select('*', { count: 'exact', head: true })
    .in(
      'goal_id',
      supabase.from('goals').select('id').eq('pack_id', packId)
    );

  // Calculate average streak
  const streaks = members?.map((m) => m.current_streak) || [];
  const averageStreak =
    streaks.length > 0
      ? streaks.reduce((a, b) => a + b, 0) / streaks.length
      : 0;

  // Get top performers (top 3)
  const topPerformers =
    members?.slice(0, 3).map((m) => ({
      user_id: m.user_id,
      username: (m.users as any)?.username || 'Unknown',
      xp: m.total_xp,
      streak: m.current_streak,
    })) || [];

  return {
    pack_id: packId,
    total_xp: pack.total_xp,
    current_level: pack.current_level,
    member_count: pack.member_count,
    total_checkins: checkinsCount || 0,
    total_fines: finesCount || 0,
    total_jails: jailsCount || 0,
    average_streak: Math.round(averageStreak * 10) / 10,
    top_performers: topPerformers,
  };
}

/**
 * Get user's packs
 */
export async function getUserPacks(
  supabase: SupabaseClient,
  userId: string
): Promise<Pack[]> {
  const { data: memberships } = await supabase
    .from('pack_members')
    .select('pack_id')
    .eq('user_id', userId);

  if (!memberships || memberships.length === 0) {
    return [];
  }

  const packIds = memberships.map((m) => m.pack_id);

  const { data: packs } = await supabase
    .from('packs')
    .select('*')
    .in('id', packIds)
    .order('created_at', { ascending: false });

  return (packs as Pack[]) || [];
}

/**
 * Find pack by invite code
 */
export async function findPackByInviteCode(
  supabase: SupabaseClient,
  inviteCode: string
): Promise<Pack> {
  const { data: pack, error } = await supabase
    .from('packs')
    .select('*')
    .eq('invite_code', inviteCode.toUpperCase())
    .single();

  if (error || !pack) {
    throw new NotFoundError('Pack with that invite code');
  }

  return pack as Pack;
}
