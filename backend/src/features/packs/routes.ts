import { Context } from 'hono';
import { getAuthenticatedUserId } from '../../middleware/auth';
import { getSupabaseClient } from '../../lib/supabase';
import { successResponse } from '../../lib/response';
import { validateBody, validateParams } from '../../utils/validation';
import { requirePackCreator, requirePackMembership } from '../../utils/permissions';
import {
  createPackSchema,
  updatePackSchema,
  addMemberSchema,
  packIdParamSchema,
  removeMemberParamSchema,
  createInviteCodeSchema,
  useInviteCodeSchema,
  inviteCodeIdParamSchema,
} from './validators';
import {
  createPack,
  getPack,
  updatePack,
  dissolvePack,
  addMember,
  removeMember,
  getPackStats,
  getUserPacks,
  findPackByInviteCode,
  createPackInviteCode,
  validatePackInviteCode,
  usePackInviteCode,
  listPackInviteCodes,
  deactivatePackInviteCode,
  deletePackInviteCode,
} from './services';

/**
 * POST /api/packs
 * Create a new pack
 */
export async function createPackHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate request body
  const input = await validateBody(c, createPackSchema);

  // Create pack
  const pack = await createPack(supabase, userId, input);

  return c.json(successResponse(pack), 201);
}

/**
 * GET /api/packs
 * Get user's packs
 */
export async function getUserPacksHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Get user's packs
  const packs = await getUserPacks(supabase, userId);

  return c.json(successResponse(packs));
}

/**
 * GET /api/packs/:id
 * Get pack details with members
 */
export async function getPackHandler(c: Context) {
  const { id: packId } = validateParams(c, packIdParamSchema);
  const supabase = getSupabaseClient(c);

  // Check pack membership
  await requirePackMembership(c, packId);

  // Get pack with members
  const pack = await getPack(supabase, packId, true);

  return c.json(successResponse(pack));
}

/**
 * PATCH /api/packs/:id
 * Update pack (creator only)
 */
export async function updatePackHandler(c: Context) {
  const { id: packId } = validateParams(c, packIdParamSchema);
  const supabase = getSupabaseClient(c);

  // Check if user is pack creator
  await requirePackCreator(c, packId);

  // Validate request body
  const updates = await validateBody(c, updatePackSchema);

  // Update pack
  const pack = await updatePack(supabase, packId, updates);

  return c.json(successResponse(pack));
}

/**
 * DELETE /api/packs/:id
 * Dissolve pack (creator only)
 */
export async function dissolvePackHandler(c: Context) {
  const { id: packId } = validateParams(c, packIdParamSchema);
  const supabase = getSupabaseClient(c);

  // Check if user is pack creator
  await requirePackCreator(c, packId);

  // Dissolve pack
  await dissolvePack(supabase, packId);

  return c.json(
    successResponse({
      message: 'Pack dissolved successfully',
    })
  );
}

/**
 * POST /api/packs/:id/members
 * Add member to pack
 */
export async function addMemberHandler(c: Context) {
  const { id: packId } = validateParams(c, packIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate request body
  const input = await validateBody(c, addMemberSchema);

  let targetUserId: string;

  if (input.invite_code) {
    // User joining with invite code
    const pack = await findPackByInviteCode(supabase, input.invite_code);
    if (pack.id !== packId) {
      throw new Error('Invite code does not match this pack');
    }
    targetUserId = userId; // User is joining themselves
  } else if (input.user_id) {
    // Creator adding another user
    await requirePackCreator(c, packId);
    targetUserId = input.user_id;
  } else {
    throw new Error('Either user_id or invite_code must be provided');
  }

  // Add member
  const member = await addMember(supabase, packId, targetUserId, c.env);

  return c.json(successResponse(member), 201);
}

/**
 * DELETE /api/packs/:id/members/:userId
 * Remove member from pack
 */
export async function removeMemberHandler(c: Context) {
  const { id: packId, userId: targetUserId } = validateParams(
    c,
    removeMemberParamSchema
  );
  const requesterId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // User can remove themselves or admin can remove others
  if (targetUserId !== requesterId) {
    await requirePackCreator(c, packId);
  }

  // Remove member
  await removeMember(supabase, packId, targetUserId, requesterId);

  return c.json(
    successResponse({
      message: 'Member removed successfully',
    })
  );
}

/**
 * GET /api/packs/:id/stats
 * Get pack statistics
 */
export async function getPackStatsHandler(c: Context) {
  const { id: packId } = validateParams(c, packIdParamSchema);
  const supabase = getSupabaseClient(c);

  // Check pack membership
  await requirePackMembership(c, packId);

  // Get stats
  const stats = await getPackStats(supabase, packId);

  return c.json(successResponse(stats));
}

/**
 * POST /api/packs/:id/invite-codes
 * Create a new invite code for a pack
 */
export async function createInviteCodeHandler(c: Context) {
  const { id: packId } = validateParams(c, packIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate request body
  const input = await validateBody(c, createInviteCodeSchema);

  // Create invite code
  const inviteCode = await createPackInviteCode(supabase, packId, userId, input);

  return c.json(successResponse(inviteCode), 201);
}

/**
 * GET /api/packs/:id/invite-codes
 * List all invite codes for a pack
 */
export async function listInviteCodesHandler(c: Context) {
  const { id: packId } = validateParams(c, packIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // List invite codes
  const inviteCodes = await listPackInviteCodes(supabase, packId, userId);

  return c.json(successResponse(inviteCodes));
}

/**
 * GET /api/invite-codes/:code/validate
 * Validate an invite code
 */
export async function validateInviteCodeHandler(c: Context) {
  const code = c.req.param('code');
  const supabase = getSupabaseClient(c);

  // Validate code
  const validation = await validatePackInviteCode(supabase, code);

  return c.json(successResponse(validation));
}

/**
 * POST /api/invite-codes/use
 * Use an invite code to join a pack
 */
export async function useInviteCodeHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate request body
  const input = await validateBody(c, useInviteCodeSchema);

  // Use invite code
  const result = await usePackInviteCode(supabase, userId, input.code);

  return c.json(successResponse(result), 201);
}

/**
 * PATCH /api/packs/:id/invite-codes/:codeId/deactivate
 * Deactivate an invite code
 */
export async function deactivateInviteCodeHandler(c: Context) {
  const { codeId } = validateParams(c, inviteCodeIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Deactivate invite code
  await deactivatePackInviteCode(supabase, codeId, userId);

  return c.json(successResponse({ message: 'Invite code deactivated' }));
}

/**
 * DELETE /api/packs/:id/invite-codes/:codeId
 * Delete an invite code
 */
export async function deleteInviteCodeHandler(c: Context) {
  const { codeId } = validateParams(c, inviteCodeIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Delete invite code
  await deletePackInviteCode(supabase, codeId, userId);

  return c.json(successResponse({ message: 'Invite code deleted' }));
}
