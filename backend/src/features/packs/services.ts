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
  // Use database function to create pack and add creator as member
  // This bypasses RLS recursion issues between packs and pack_members
  const { data, error: packError } = await supabase
    .rpc('create_pack_with_creator', {
      p_name: input.name,
      p_creator_id: userId,
      p_goal_type: input.goal_type || 'general',
    });

  console.log('RPC Response:', { data, error: packError });

  if (packError) {
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

  // RPC returns array of rows, get first one
  const pack = Array.isArray(data) ? data[0] : data;

  if (!pack) {
    console.error('Pack creation returned null', { data });
    throw new InternalError('Failed to create pack - no data returned');
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

  // Count current members
  const { count: memberCount } = await supabase
    .from('pack_members')
    .select('*', { count: 'exact', head: true })
    .eq('pack_id', packId)
    .eq('is_active', true);

  // Validate member limit
  if (!validateMemberLimit(memberCount || 0, 1)) {
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
      reputation_xp: 0,
      is_active: true,
    })
    .select('*, users:user_id(username, display_name, avatar_url)')
    .single();

  if (error || !member) {
    console.error('Member addition error:', error);
    throw new InternalError('Failed to add member to pack');
  }

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

  // Count remaining members
  const { count: remainingCount } = await supabase
    .from('pack_members')
    .select('*', { count: 'exact', head: true })
    .eq('pack_id', packId)
    .eq('is_active', true);

  // Check if pack still meets minimum requirement
  if ((remainingCount || 0) < 3) {
    // Optionally dissolve pack or mark as inactive
    console.warn(`Pack ${packId} now has less than 3 members`);
  }
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
    .select('user_id, reputation_xp')
    .eq('pack_id', packId)
    .eq('is_active', true)
    .order('reputation_xp', { ascending: false });

  // Get goal IDs for this pack
  const { data: goals } = await supabase
    .from('goals')
    .select('id')
    .eq('pack_id', packId);

  const goalIds = goals?.map(g => g.id) || [];

  // Get check-ins count (only if we have goals)
  let checkinsCount = 0;
  if (goalIds.length > 0) {
    const { count } = await supabase
      .from('check_ins')
      .select('*', { count: 'exact', head: true })
      .in('goal_id', goalIds);
    checkinsCount = count || 0;
  }

  // Get fines count
  const { count: finesCount } = await supabase
    .from('fines')
    .select('*', { count: 'exact', head: true })
    .eq('pack_id', packId);

  // Get jails count (only if we have goals)
  let jailsCount = 0;
  if (goalIds.length > 0) {
    const { count } = await supabase
      .from('phone_jails')
      .select('*', { count: 'exact', head: true })
      .in('goal_id', goalIds);
    jailsCount = count || 0;
  }

  // Get top performers (top 3) based on reputation XP
  const topPerformers =
    members?.slice(0, 3).map((m) => ({
      user_id: m.user_id,
      username: m.user_id, // Just use user_id since username might be null
      xp: m.reputation_xp,
      streak: 0, // TODO: Calculate from check_ins
    })) || [];

  return {
    pack_id: packId,
    total_xp: pack.xp,
    current_level: pack.level,
    member_count: members?.length || 0,
    total_checkins: checkinsCount || 0,
    total_fines: finesCount || 0,
    total_jails: jailsCount || 0,
    average_streak: 0, // TODO: Calculate from check_ins
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
