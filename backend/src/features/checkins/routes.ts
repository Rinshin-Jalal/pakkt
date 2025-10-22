import { Context } from 'hono';
import { getAuthenticatedUserId } from '../../middleware/auth';
import { getSupabaseClient } from '../../lib/supabase';
import { successResponse } from '../../lib/response';
import {
  validateBody,
  validateParams,
  validateQuery,
} from '../../utils/validation';
import { requireGoalAccess } from '../../utils/permissions';
import {
  createCheckInSchema,
  checkInIdParamSchema,
  feedFilterSchema,
  packCheckInsFilterSchema,
} from './validators';
import {
  createCheckIn,
  getFeed,
  getPackCheckIns,
  getCheckIn,
  getUserCheckInStats,
  deleteCheckIn,
} from './services';
import { uuidSchema } from '../../utils/validation';
import { z } from 'zod';

/**
 * POST /api/checkins
 * Create a new check-in
 */
export async function createCheckInHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);
  console.log('userId:', userId);

  // Validate request body
  const input = await validateBody(c, createCheckInSchema);
  console.log('reached here input : ', input);

  // Verify user has access to the goal
  await requireGoalAccess(c, input.goal_id);
  console.log('reached here, userId:', userId);

  // Create check-in
  const checkIn = await createCheckIn(supabase, userId, input);
  console.log('reached here ');

  return c.json(successResponse(checkIn), 201);
}

/**
 * GET /api/checkins/feed
 * Get feed of check-ins from user's packs
 */
export async function getFeedHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Parse filters
  const filters = validateQuery(c, feedFilterSchema);

  // Get feed
  const feed = await getFeed(supabase, userId, filters);

  return c.json(successResponse(feed));
}

/**
 * GET /api/packs/:packId/checkins
 * Get check-ins for a specific pack
 */
export async function getPackCheckInsHandler(c: Context) {
  const { packId } = validateParams(c, z.object({ packId: uuidSchema }));
  const supabase = getSupabaseClient(c);

  // Parse filters
  const filters = validateQuery(c, packCheckInsFilterSchema);

  // Get pack check-ins
  const checkIns = await getPackCheckIns(supabase, packId, filters);

  return c.json(successResponse(checkIns));
}

/**
 * GET /api/checkins/:id
 * Get a specific check-in
 */
export async function getCheckInHandler(c: Context) {
  const { id: checkInId } = validateParams(c, checkInIdParamSchema);
  const supabase = getSupabaseClient(c);

  // Get check-in
  const checkIn = await getCheckIn(supabase, checkInId);

  // Verify user has access to the pack
  await requireGoalAccess(c, checkIn.goal_id);

  return c.json(successResponse(checkIn));
}

/**
 * GET /api/checkins/stats
 * Get user's check-in statistics
 */
export async function getStatsHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Get stats
  const stats = await getUserCheckInStats(supabase, userId);

  return c.json(successResponse(stats));
}

/**
 * DELETE /api/checkins/:id
 * Delete a check-in
 */
export async function deleteCheckInHandler(c: Context) {
  const { id: checkInId } = validateParams(c, checkInIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Delete check-in (ownership check inside service)
  await deleteCheckIn(supabase, checkInId, userId);

  return c.json(
    successResponse({
      message: 'Check-in deleted successfully',
    })
  );
}
