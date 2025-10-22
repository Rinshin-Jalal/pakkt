import { Context } from 'hono';
import { getAuthenticatedUserId } from '../../middleware/auth';
import { getSupabaseClient } from '../../lib/supabase';
import { successResponse } from '../../lib/response';
import { validateBody, validateParams } from '../../utils/validation';
import {
  createReactionSchema,
  createCommentSchema,
  editCommentSchema,
  reactionIdParamSchema,
  commentIdParamSchema,
  checkInIdParamSchema,
} from './validators';
import {
  addReaction,
  removeReaction,
  getCheckInReactions,
  addComment,
  editComment,
  deleteComment,
  getCheckInComments,
  getFeedEvents,
} from './services';

/**
 * POST /api/reactions
 * Add or update reaction
 */
export async function addReactionHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate request body
  const input = await validateBody(c, createReactionSchema);

  // Add reaction
  const reaction = await addReaction(supabase, userId, input);

  return c.json(successResponse(reaction), 201);
}

/**
 * DELETE /api/reactions/:id
 * Remove reaction
 */
export async function removeReactionHandler(c: Context) {
  const { id: reactionId } = validateParams(c, reactionIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Remove reaction
  await removeReaction(supabase, reactionId, userId);

  return c.json(
    successResponse({
      message: 'Reaction removed successfully',
    })
  );
}

/**
 * GET /api/checkins/:checkInId/reactions
 * Get all reactions for a check-in
 */
export async function getReactionsHandler(c: Context) {
  const { checkInId } = validateParams(c, checkInIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Get reactions
  const result = await getCheckInReactions(supabase, checkInId, userId);

  return c.json(successResponse(result));
}

/**
 * POST /api/comments
 * Add comment to check-in
 */
export async function addCommentHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate request body
  const input = await validateBody(c, createCommentSchema);

  // Add comment
  const comment = await addComment(supabase, userId, input);

  return c.json(successResponse(comment), 201);
}

/**
 * PATCH /api/comments/:id
 * Edit comment
 */
export async function editCommentHandler(c: Context) {
  const { id: commentId } = validateParams(c, commentIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Validate request body
  const input = await validateBody(c, editCommentSchema);

  // Edit comment
  const comment = await editComment(supabase, commentId, userId, input);

  return c.json(successResponse(comment));
}

/**
 * DELETE /api/comments/:id
 * Delete comment
 */
export async function deleteCommentHandler(c: Context) {
  const { id: commentId } = validateParams(c, commentIdParamSchema);
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Delete comment
  await deleteComment(supabase, commentId, userId);

  return c.json(
    successResponse({
      message: 'Comment deleted successfully',
    })
  );
}

/**
 * GET /api/checkins/:checkInId/comments
 * Get all comments for a check-in
 */
export async function getCommentsHandler(c: Context) {
  const { checkInId } = validateParams(c, checkInIdParamSchema);
  const supabase = getSupabaseClient(c);

  // Get comments
  const comments = await getCheckInComments(supabase, checkInId);

  return c.json(successResponse(comments));
}

/**
 * GET /api/feed-events
 * Get feed events for user's packs
 */
export async function getFeedEventsHandler(c: Context) {
  const userId = getAuthenticatedUserId(c);
  const supabase = getSupabaseClient(c);

  // Parse query params
  const limit = parseInt(c.req.query('limit') || '20');
  const offset = parseInt(c.req.query('offset') || '0');

  // Get feed events
  const events = await getFeedEvents(supabase, userId, limit, offset);

  return c.json(successResponse(events));
}
