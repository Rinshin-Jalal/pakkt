import { Context } from 'hono';
import { getAuthenticatedUserId } from '../../middleware/auth';
import { getSupabaseClient } from '../../lib/supabase';
import { successResponse } from '../../lib/response';
import { validateBody, validateParams, validateQuery } from '../../utils/validation';
import { requirePackMembership } from '../../utils/permissions';
import {
  createGoalSchema,
  updateGoalSchema,
  goalIdParamSchema,
  packGoalsParamSchema,
  goalsFilterSchema,
} from './validators';
import {
  createGoal,
  listPackGoals,
  getGoal,
  updateGoal,
  deleteGoal,
  toggleGoalStatus,
  getGoalWithStats,
  getUserActiveGoals,
} from './services';

/**
 * POST /api/packs/:packId/goals
 * Create a new goal for a pack
 */
export async function createGoalHandler(c: Context) {
  const { packId } = validateParams(c, packGoalsParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Check pack membership
  await requirePackMembership(c, packId);

  // Validate request body
  const input = await validateBody(c, createGoalSchema);

  // Create goal
  const goal = await createGoal(supabase, packId, userId, input);

  return c.json(successResponse(goal), 201);
}

/**
 * GET /api/packs/:packId/goals
 * List all goals for a pack
 */
export async function listPackGoalsHandler(c: Context) {
  const { packId } = validateParams(c, packGoalsParamSchema);
  const supabase = getSupabaseClient(c);

  // Check pack membership
  await requirePackMembership(c, packId);

  // Parse filters
  const filters = validateQuery(c, goalsFilterSchema);

  // Get goals
  const goals = await listPackGoals(supabase, packId, filters);

  return c.json(successResponse(goals));
}

/**
 * GET /api/goals/my-active
 * Get all active goals for current user
 */
export async function getMyActiveGoalsHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Get user's active goals
  const goals = await getUserActiveGoals(supabase, userId);

  return c.json(successResponse(goals));
}

/**
 * GET /api/goals/:id
 * Get goal details
 */
export async function getGoalHandler(c: Context) {
  const { id: goalId } = validateParams(c, goalIdParamSchema);
  const supabase = getSupabaseClient(c);

  // Get goal
  const goal = await getGoal(supabase, goalId);

  // Check pack membership
  await requirePackMembership(c, goal.pack_id);

  return c.json(successResponse(goal));
}

/**
 * GET /api/goals/:id/stats
 * Get goal with statistics
 */
export async function getGoalStatsHandler(c: Context) {
  const { id: goalId } = validateParams(c, goalIdParamSchema);
  const supabase = getSupabaseClient(c);

  // Get goal with stats
  const goalWithStats = await getGoalWithStats(supabase, goalId);

  // Check pack membership
  await requirePackMembership(c, goalWithStats.pack_id);

  return c.json(successResponse(goalWithStats));
}

/**
 * PATCH /api/goals/:id
 * Update a goal
 */
export async function updateGoalHandler(c: Context) {
  const { id: goalId } = validateParams(c, goalIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate request body
  const updates = await validateBody(c, updateGoalSchema);

  // Update goal (ownership check inside service)
  const goal = await updateGoal(supabase, goalId, userId, updates);

  return c.json(successResponse(goal));
}

/**
 * DELETE /api/goals/:id
 * Delete a goal
 */
export async function deleteGoalHandler(c: Context) {
  const { id: goalId } = validateParams(c, goalIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Delete goal (ownership check inside service)
  await deleteGoal(supabase, goalId, userId);

  return c.json(
    successResponse({
      message: 'Goal deleted successfully',
    })
  );
}

/**
 * POST /api/goals/:id/toggle
 * Toggle goal active status
 */
export async function toggleGoalHandler(c: Context) {
  const { id: goalId } = validateParams(c, goalIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Toggle goal status (ownership check inside service)
  const goal = await toggleGoalStatus(supabase, goalId, userId);

  return c.json(successResponse(goal));
}
