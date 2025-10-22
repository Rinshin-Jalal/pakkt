import { Context } from 'hono';
import { getAuthenticatedUserId } from '../../middleware/auth';
import { getSupabaseClient } from '../../lib/supabase';
import { successResponse } from '../../lib/response';
import { validateBody, validateParams } from '../../utils/validation';
import { requireGoalAccess } from '../../utils/permissions';
import {
  startJailSchema,
  heartbeatSchema,
  breakJailSchema,
  jailIdParamSchema,
} from './validators';
import {
  startJailSession,
  sendHeartbeat,
  breakJailEarly,
  getJailSession,
  getActiveJailSessions,
} from './services';

/**
 * POST /api/jail/start
 * Start a new jail session
 */
export async function startJailHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate request body
  const input = await validateBody(c, startJailSchema);

  // Verify user has access to the goal
  await requireGoalAccess(c, input.goal_id);

  // Start jail session
  const session = await startJailSession(supabase, userId, input);

  return c.json(successResponse(session), 201);
}

/**
 * GET /api/jail/active
 * Get active jail sessions for current user
 */
export async function getActiveSessionsHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Get active sessions
  const sessions = await getActiveJailSessions(supabase, userId);

  return c.json(successResponse(sessions));
}

/**
 * GET /api/jail/:id
 * Get jail session status and progress
 */
export async function getJailSessionHandler(c: Context) {
  const { id: jailId } = validateParams(c, jailIdParamSchema);
  const supabase = getSupabaseClient(c);

  // Get session
  const session = await getJailSession(supabase, jailId);

  return c.json(successResponse(session));
}

/**
 * POST /api/jail/:id/heartbeat
 * Send heartbeat to keep session active
 */
export async function heartbeatHandler(c: Context) {
  const { id: jailId } = validateParams(c, jailIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate heartbeat input
  const input = await validateBody(c, heartbeatSchema);

  // Send heartbeat
  const session = await sendHeartbeat(supabase, jailId, userId, input);

  return c.json(successResponse(session));
}

/**
 * POST /api/jail/:id/break
 * Break jail early (pay 2x fine)
 */
export async function breakJailHandler(c: Context) {
  const { id: jailId } = validateParams(c, jailIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate break jail input
  const input = await validateBody(c, breakJailSchema);

  // Break jail
  const session = await breakJailEarly(supabase, jailId, userId, input);

  return c.json(successResponse(session));
}
