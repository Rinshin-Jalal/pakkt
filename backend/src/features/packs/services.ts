import { SupabaseClient } from '@supabase/supabase-js';
import {
  NotFoundError,
  ConflictError,
  InternalError,
  ForbiddenError,
  ValidationError,
} from '../../lib/errors';
import { createSupabaseClient } from '../../lib/supabase';
import type { Env } from '../../types/env';
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
      .select('*, users:user_id(username, profile_pic)')
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
  userId: string,
  env: Env
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

  // Add member using service role client to bypass RLS
  // Note: We use service role here because auth.uid() is null in server context
  // Permissions are already checked in the route handler (requirePackCreator)
  const serviceSupabase = createSupabaseClient(env);

  const { data: member, error } = await serviceSupabase
    .from('pack_members')
    .insert({
      pack_id: packId,
      user_id: userId,
      role: 'member',
      reputation_xp: 0,
      is_active: true,
    })
    .select('*, users:user_id(username, profile_pic)')
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
 * Find pack by invite code (DEPRECATED - use new invite code system)
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

/**
 * Create a new invite code for a pack
 */
export async function createPackInviteCode(
  supabase: SupabaseClient,
  packId: string,
  userId: string,
  input: { max_uses?: number; expires_in_hours?: number }
): Promise<any> {
  // Verify user is pack creator
  const { data: pack } = await supabase
    .from('packs')
    .select('creator_id')
    .eq('id', packId)
    .single();

  if (!pack) {
    throw new NotFoundError('Pack');
  }

  if (pack.creator_id !== userId) {
    throw new ForbiddenError('Only pack creator can create invite codes');
  }

  // Generate unique code
  const code = generateInviteCode();

  // Calculate expiration
  const expiresInHours = input.expires_in_hours || 24;
  const expiresAt = new Date();
  expiresAt.setHours(expiresAt.getHours() + expiresInHours);

  // Create invite code
  const { data: inviteCode, error } = await supabase
    .from('pack_invite_codes')
    .insert({
      pack_id: packId,
      code,
      created_by: userId,
      max_uses: input.max_uses || 1,
      current_uses: 0,
      expires_at: expiresAt.toISOString(),
      is_active: true,
    })
    .select()
    .single();

  if (error || !inviteCode) {
    console.error('Invite code creation error:', error);
    throw new InternalError('Failed to create invite code');
  }

  return inviteCode;
}

/**
 * Validate an invite code (check if it's usable)
 */
export async function validatePackInviteCode(
  supabase: SupabaseClient,
  code: string
): Promise<{ valid: boolean; pack_id?: string; reason?: string }> {
  const { data: inviteCode } = await supabase
    .from('pack_invite_codes')
    .select('*, packs:pack_id(name)')
    .eq('code', code)
    .single();

  if (!inviteCode) {
    return { valid: false, reason: 'Invalid invite code' };
  }

  if (!inviteCode.is_active) {
    return { valid: false, reason: 'Invite code is no longer active' };
  }

  if (new Date(inviteCode.expires_at) < new Date()) {
    return { valid: false, reason: 'Invite code has expired' };
  }

  if (inviteCode.current_uses >= inviteCode.max_uses) {
    return { valid: false, reason: 'Invite code has reached maximum uses' };
  }

  return {
    valid: true,
    pack_id: inviteCode.pack_id,
  };
}

/**
 * Use an invite code to join a pack
 */
export async function usePackInviteCode(
  supabase: SupabaseClient,
  userId: string,
  code: string
): Promise<{ pack: Pack; member: PackMember }> {
  // Use database function for atomic operation
  // Function returns pack and member details directly (bypasses RLS)
  const { data, error } = await supabase
    .rpc('use_invite_code', {
      p_code: code,
      p_user_id: userId,
    })
    .single();

  if (error) {
    console.error('Invite code usage error:', error);
    if (error.message.includes('already a member')) {
      throw new ConflictError('You are already a member of this pack');
    }
    if (error.message.includes('Invalid or expired')) {
      throw new ValidationError('Invalid or expired invite code');
    }
    throw new InternalError('Failed to use invite code');
  }

  if (!data) {
    throw new InternalError('Failed to join pack');
  }

  // Function returns both pack and member data
  const pack: Pack = {
    id: data.result_pack_id,
    name: data.result_pack_name,
    creator_id: data.result_pack_creator_id,
    xp: data.result_pack_xp,
    level: data.result_pack_level,
    status: data.result_pack_status,
    created_at: '', // Not returned by function but not critical
    updated_at: '',
  };

  const member: PackMember = {
    id: data.result_member_id,
    pack_id: data.result_pack_id,
    user_id: userId,
    role: data.result_member_role,
    reputation_xp: data.result_member_reputation_xp,
    is_active: true,
    join_date: new Date().toISOString(),
    created_at: '',
    updated_at: '',
  };

  return { pack, member };
}

/**
 * List all invite codes for a pack
 */
export async function listPackInviteCodes(
  supabase: SupabaseClient,
  packId: string,
  userId: string
): Promise<any[]> {
  // Verify user is pack creator
  const { data: pack } = await supabase
    .from('packs')
    .select('creator_id')
    .eq('id', packId)
    .single();

  if (!pack) {
    throw new NotFoundError('Pack');
  }

  if (pack.creator_id !== userId) {
    throw new ForbiddenError('Only pack creator can view invite codes');
  }

  // Get invite codes
  const { data: inviteCodes } = await supabase
    .from('pack_invite_codes')
    .select('*')
    .eq('pack_id', packId)
    .order('created_at', { ascending: false });

  return inviteCodes || [];
}

/**
 * Deactivate an invite code
 */
export async function deactivatePackInviteCode(
  supabase: SupabaseClient,
  codeId: string,
  userId: string
): Promise<void> {
  // Get invite code with pack info
  const { data: inviteCode } = await supabase
    .from('pack_invite_codes')
    .select('*, packs:pack_id(creator_id)')
    .eq('id', codeId)
    .single();

  if (!inviteCode) {
    throw new NotFoundError('Invite code');
  }

  // Verify user is pack creator
  if (inviteCode.packs.creator_id !== userId) {
    throw new ForbiddenError('Only pack creator can deactivate invite codes');
  }

  // Deactivate
  const { error } = await supabase
    .from('pack_invite_codes')
    .update({ is_active: false, updated_at: new Date().toISOString() })
    .eq('id', codeId);

  if (error) {
    console.error('Deactivate invite code error:', error);
    throw new InternalError('Failed to deactivate invite code');
  }
}

/**
 * Delete an invite code
 */
export async function deletePackInviteCode(
  supabase: SupabaseClient,
  codeId: string,
  userId: string
): Promise<void> {
  // Get invite code with pack info
  const { data: inviteCode } = await supabase
    .from('pack_invite_codes')
    .select('*, packs:pack_id(creator_id)')
    .eq('id', codeId)
    .single();

  if (!inviteCode) {
    throw new NotFoundError('Invite code');
  }

  // Verify user is pack creator
  if (inviteCode.packs.creator_id !== userId) {
    throw new ForbiddenError('Only pack creator can delete invite codes');
  }

  // Delete
  const { error } = await supabase
    .from('pack_invite_codes')
    .delete()
    .eq('id', codeId);

  if (error) {
    console.error('Delete invite code error:', error);
    throw new InternalError('Failed to delete invite code');
  }
}
