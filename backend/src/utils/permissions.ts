import { Context } from 'hono';
import { ForbiddenError, NotFoundError } from '../lib/errors';
import { getSupabaseClient } from '../lib/supabase';
import { getAuthenticatedUserId } from '../middleware/auth';

/**
 * Check if user is a member of a pack
 * @throws ForbiddenError if user is not a member
 */
export async function requirePackMembership(
  c: Context,
  packId: string
): Promise<void> {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // First check if user is the pack creator (no RLS issues)
  const { data: pack } = await supabase
    .from('packs')
    .select('creator_id')
    .eq('id', packId)
    .single();

  if (pack && pack.creator_id === userId) {
    return; // User is the creator, they have access
  }

  // Then check pack_members (may be blocked by RLS in some cases)
  const { data, error } = await supabase
    .from('pack_members')
    .select('user_id')
    .eq('pack_id', packId)
    .eq('user_id', userId)
    .single();

  if (error || !data) {
    console.error('Pack membership check failed:', { userId, packId, error });
    throw new ForbiddenError('You must be a member of this pack');
  }
}

/**
 * Check if user is the creator/admin of a pack
 * @throws ForbiddenError if user is not the creator
 */
export async function requirePackCreator(
  c: Context,
  packId: string
): Promise<void> {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  const { data, error } = await supabase
    .from('packs')
    .select('creator_id')
    .eq('id', packId)
    .single();

  if (error || !data) {
    throw new NotFoundError('Pack');
  }

  if (data.creator_id !== userId) {
    throw new ForbiddenError('Only the pack creator can perform this action');
  }
}

/**
 * Check if user is a pack admin (creator or admin role)
 * @throws ForbiddenError if user is not an admin
 */
export async function requirePackAdmin(
  c: Context,
  packId: string
): Promise<void> {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Check if user is creator
  const { data: pack } = await supabase
    .from('packs')
    .select('creator_id')
    .eq('id', packId)
    .single();

  if (pack && pack.creator_id === userId) {
    return; // User is creator
  }

  // Check if user is admin member
  const { data: member, error } = await supabase
    .from('pack_members')
    .select('role')
    .eq('pack_id', packId)
    .eq('user_id', userId)
    .single();

  if (error || !member || member.role !== 'admin') {
    throw new ForbiddenError('Admin privileges required');
  }
}

/**
 * Check if user owns a resource
 * @throws ForbiddenError if user does not own the resource
 */
export async function requireResourceOwnership(
  c: Context,
  table: string,
  resourceId: string,
  ownerField: string = 'user_id'
): Promise<void> {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  const { data, error } = await supabase
    .from(table)
    .select(ownerField)
    .eq('id', resourceId)
    .single();

  if (error || !data) {
    throw new NotFoundError(table);
  }

  if (data[ownerField] !== userId) {
    throw new ForbiddenError('You do not have permission to access this resource');
  }
}

/**
 * Check if user is member of pack that owns a goal
 * @throws ForbiddenError if user cannot access the goal
 */
export async function requireGoalAccess(
  c: Context,
  goalId: string
): Promise<void> {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Get goal's pack
  const { data: goal, error: goalError } = await supabase
    .from('goals')
    .select('pack_id')
    .eq('id', goalId)
    .single();

  if (goalError || !goal) {
    throw new NotFoundError('Goal');
  }

  // Check pack membership
  await requirePackMembership(c, goal.pack_id);
}

/**
 * Check if user can access a check-in (must be pack member)
 * @throws ForbiddenError if user cannot access the check-in
 */
export async function requireCheckInAccess(
  c: Context,
  checkInId: string
): Promise<void> {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Get check-in's goal and pack
  const { data: checkIn, error } = await supabase
    .from('check_ins')
    .select('goal_id, goals(pack_id)')
    .eq('id', checkInId)
    .single();

  if (error || !checkIn) {
    throw new NotFoundError('Check-in');
  }

  // Check pack membership
  const packId = (checkIn.goals as any)?.pack_id;
  if (packId) {
    await requirePackMembership(c, packId);
  }
}

/**
 * Get user's packs
 * Returns array of pack IDs the user is a member of
 */
export async function getUserPacks(c: Context): Promise<string[]> {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  const { data, error } = await supabase
    .from('pack_members')
    .select('pack_id')
    .eq('user_id', userId);

  if (error) {
    return [];
  }

  return data.map((m) => m.pack_id);
}
