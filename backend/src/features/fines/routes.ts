import { Context } from 'hono';
import { getAuthenticatedUserId } from '../../middleware/auth';
import { getSupabaseClient } from '../../lib/supabase';
import { successResponse } from '../../lib/response';
import { validateBody, validateParams, validateQuery } from '../../utils/validation';
import { requirePackMembership } from '../../utils/permissions';
import {
  createFineSchema,
  voteSchema,
  appealSchema,
  fineIdParamSchema,
  packFinesFilterSchema,
} from './validators';
import {
  createFine,
  getFineWithVotes,
  castVote,
  resolveFine,
  appealFine,
  listPackFines,
  getUserFines,
} from './services';
import { uuidSchema } from '../../utils/validation';
import { z } from 'zod';

/**
 * POST /api/fines
 * Create a new fine
 */
export async function createFineHandler(c: Context) {
  const creatorId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate request body
  const input = await validateBody(c, createFineSchema);

  // Get goal's pack_id
  const { data: goal } = await supabase
    .from('goals')
    .select('pack_id')
    .eq('id', input.goal_id)
    .single();

  if (!goal) {
    throw new Error('Goal not found');
  }

  // Check pack membership
  await requirePackMembership(c, goal.pack_id);

  // Create fine
  const fine = await createFine(supabase, goal.pack_id, creatorId, input);

  return c.json(successResponse(fine), 201);
}

/**
 * GET /api/fines/my
 * Get current user's fines
 */
export async function getMyFinesHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Get user's fines
  const fines = await getUserFines(supabase, userId);

  return c.json(successResponse(fines));
}

/**
 * GET /api/fines/:id
 * Get fine details with vote count
 */
export async function getFineHandler(c: Context) {
  const { id: fineId } = validateParams(c, fineIdParamSchema);
  const supabase = getSupabaseClient(c);

  // Get fine with votes
  const fine = await getFineWithVotes(supabase, fineId);

  // Check pack membership
  await requirePackMembership(c, fine.pack_id);

  return c.json(successResponse(fine));
}

/**
 * POST /api/fines/:id/vote
 * Cast vote on a fine
 */
export async function voteHandler(c: Context) {
  const { id: fineId } = validateParams(c, fineIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Get fine's pack_id
  const { data: fine } = await supabase
    .from('fines')
    .select('pack_id')
    .eq('id', fineId)
    .single();

  if (!fine) {
    throw new Error('Fine not found');
  }

  // Check pack membership
  await requirePackMembership(c, fine.pack_id);

  // Validate vote input
  const input = await validateBody(c, voteSchema);

  // Cast vote
  const vote = await castVote(supabase, fineId, userId, input);

  return c.json(successResponse(vote), 201);
}

/**
 * POST /api/fines/:id/resolve
 * Manually resolve fine after voting window
 */
export async function resolveHandler(c: Context) {
  const { id: fineId } = validateParams(c, fineIdParamSchema);
  const supabase = getSupabaseClient(c);

  // Get fine's pack_id
  const { data: fine } = await supabase
    .from('fines')
    .select('pack_id')
    .eq('id', fineId)
    .single();

  if (!fine) {
    throw new Error('Fine not found');
  }

  // Check pack membership (any member can resolve)
  await requirePackMembership(c, fine.pack_id);

  // Resolve fine
  const resolvedFine = await resolveFine(supabase, fineId);

  return c.json(successResponse(resolvedFine));
}

/**
 * POST /api/fines/:id/appeal
 * Appeal an enforced fine
 */
export async function appealHandler(c: Context) {
  const { id: fineId } = validateParams(c, fineIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate appeal input
  const input = await validateBody(c, appealSchema);

  // Appeal fine
  const appealedFine = await appealFine(supabase, fineId, userId, input);

  return c.json(successResponse(appealedFine));
}

/**
 * GET /api/packs/:packId/fines
 * List fines for a pack
 */
export async function listPackFinesHandler(c: Context) {
  const { packId } = validateParams(c, z.object({ packId: uuidSchema }));
  const supabase = getSupabaseClient(c);

  // Check pack membership
  await requirePackMembership(c, packId);

  // Parse filters
  const filters = validateQuery(c, packFinesFilterSchema);

  // Get pack fines
  const fines = await listPackFines(supabase, packId, filters);

  return c.json(successResponse(fines));
}
