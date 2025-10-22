import { Context } from 'hono';
import { getAuthenticatedUserId } from '../../middleware/auth';
import { getSupabaseClient } from '../../lib/supabase';
import { successResponse } from '../../lib/response';
import { validateBody } from '../../utils/validation';
import { updateProfileSchema, pushTokenSchema } from './validators';
import {
  getUserProfile,
  updateUserProfile,
  registerPushToken,
  deletePushToken,
} from './services';
import { z } from 'zod';

/**
 * GET /api/users/profile
 * Get current user profile
 */
export async function getProfile(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const userEmail = c.get('userEmail') as string;
  const supabase = getSupabaseClient(c);

  const profile = await getUserProfile(supabase, userId, userEmail);

  return c.json(successResponse(profile));
}

/**
 * PATCH /api/users/profile
 * Update user profile
 */
export async function updateProfile(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate request body
  const updates = await validateBody(c, updateProfileSchema);

  // Update profile
  const profile = await updateUserProfile(supabase, userId, updates);

  return c.json(successResponse(profile));
}

/**
 * POST /api/users/push-token
 * Register push notification token
 */
export async function addPushToken(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate request body
  const tokenData = await validateBody(c, pushTokenSchema);

  // Register token
  await registerPushToken(supabase, userId, tokenData);

  return c.json(
    successResponse({
      message: 'Push token registered successfully',
    })
  );
}

/**
 * DELETE /api/users/push-token
 * Remove push notification token
 */
export async function removePushToken(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate request body
  const { token } = await validateBody(
    c,
    z.object({
      token: z.string().min(1, 'Token is required'),
    })
  );

  // Delete token
  await deletePushToken(supabase, userId, token);

  return c.json(
    successResponse({
      message: 'Push token removed successfully',
    })
  );
}
