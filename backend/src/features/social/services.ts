import { SupabaseClient } from '@supabase/supabase-js';
import {
  NotFoundError,
  InternalError,
  ForbiddenError,
  ValidationError,
  ConflictError,
} from '../../lib/errors';
import type {
  Reaction,
  Comment,
  FeedEvent,
  CreateReactionInput,
  CreateCommentInput,
  EditCommentInput,
  CreateFeedEventInput,
  ReactionCounts,
} from './types';
import {
  hasUserReacted,
  groupReactionsByEmoji,
  canEditComment,
  determineFeedEventVisibility,
  sortComments,
} from './utils';

/**
 * Add or update reaction
 */
export async function addReaction(
  supabase: SupabaseClient,
  userId: string,
  input: CreateReactionInput
): Promise<Reaction> {
  // Check if user already reacted to this item
  let query = supabase.from('reactions').select('*').eq('user_id', userId);

  if (input.check_in_id) {
    query = query.eq('check_in_id', input.check_in_id);
  } else if (input.feed_event_id) {
    query = query.eq('feed_event_id', input.feed_event_id);
  }

  const { data: existing } = await query.single();

  // If exists, update emoji
  if (existing) {
    const { data: updated, error } = await supabase
      .from('reactions')
      .update({
        emoji: input.emoji,
        updated_at: new Date().toISOString(),
      })
      .eq('id', existing.id)
      .select('*, user:users(username, display_name, avatar_url)')
      .single();

    if (error || !updated) {
      console.error('Reaction update error:', error);
      throw new InternalError('Failed to update reaction');
    }

    return {
      ...updated,
      user: updated.user,
    } as Reaction;
  }

  // Create new reaction
  const { data: reaction, error } = await supabase
    .from('reactions')
    .insert({
      user_id: userId,
      check_in_id: input.check_in_id,
      feed_event_id: input.feed_event_id,
      emoji: input.emoji,
    })
    .select('*, user:users(username, display_name, avatar_url)')
    .single();

  if (error || !reaction) {
    console.error('Reaction creation error:', error);
    throw new InternalError('Failed to create reaction');
  }

  return {
    ...reaction,
    user: reaction.user,
  } as Reaction;
}

/**
 * Remove reaction
 */
export async function removeReaction(
  supabase: SupabaseClient,
  reactionId: string,
  userId: string
): Promise<void> {
  // Get reaction
  const { data: reaction } = await supabase
    .from('reactions')
    .select('user_id')
    .eq('id', reactionId)
    .single();

  if (!reaction) {
    throw new NotFoundError('Reaction');
  }

  // Only owner can remove
  if (reaction.user_id !== userId) {
    throw new ForbiddenError('You can only remove your own reactions');
  }

  const { error } = await supabase.from('reactions').delete().eq('id', reactionId);

  if (error) {
    console.error('Reaction deletion error:', error);
    throw new InternalError('Failed to remove reaction');
  }
}

/**
 * Get reactions for a check-in
 */
export async function getCheckInReactions(
  supabase: SupabaseClient,
  checkInId: string,
  currentUserId?: string
): Promise<{ reactions: Reaction[]; counts: ReactionCounts }> {
  const { data: reactions, error } = await supabase
    .from('reactions')
    .select('*, user:users(username, display_name, avatar_url)')
    .eq('check_in_id', checkInId)
    .order('created_at', { ascending: false });

  if (error) {
    console.error('Reactions fetch error:', error);
    return { reactions: [], counts: {} };
  }

  const reactionsList = (reactions || []).map((r) => ({
    ...r,
    user: r.user,
  })) as Reaction[];

  const counts = groupReactionsByEmoji(reactionsList, currentUserId);

  return {
    reactions: reactionsList,
    counts,
  };
}

/**
 * Add comment to check-in
 */
export async function addComment(
  supabase: SupabaseClient,
  userId: string,
  input: CreateCommentInput
): Promise<Comment> {
  // Verify check-in exists
  const { data: checkIn } = await supabase
    .from('check_ins')
    .select('id')
    .eq('id', input.check_in_id)
    .single();

  if (!checkIn) {
    throw new NotFoundError('Check-in');
  }

  // Create comment
  const { data: comment, error } = await supabase
    .from('comments')
    .insert({
      check_in_id: input.check_in_id,
      user_id: userId,
      content: input.content,
      edited: false,
    })
    .select('*, user:users(username, display_name, avatar_url)')
    .single();

  if (error || !comment) {
    console.error('Comment creation error:', error);
    throw new InternalError('Failed to create comment');
  }

  return {
    ...comment,
    user: comment.user,
  } as Comment;
}

/**
 * Edit comment
 */
export async function editComment(
  supabase: SupabaseClient,
  commentId: string,
  userId: string,
  input: EditCommentInput
): Promise<Comment> {
  // Get comment
  const { data: comment } = await supabase
    .from('comments')
    .select('user_id, created_at')
    .eq('id', commentId)
    .single();

  if (!comment) {
    throw new NotFoundError('Comment');
  }

  // Only author can edit
  if (comment.user_id !== userId) {
    throw new ForbiddenError('You can only edit your own comments');
  }

  // Check if within edit window (5 minutes)
  if (!canEditComment(comment.created_at)) {
    throw new ForbiddenError('Comments can only be edited within 5 minutes');
  }

  // Update comment
  const { data: updated, error } = await supabase
    .from('comments')
    .update({
      content: input.content,
      edited: true,
      updated_at: new Date().toISOString(),
    })
    .eq('id', commentId)
    .select('*, user:users(username, display_name, avatar_url)')
    .single();

  if (error || !updated) {
    console.error('Comment update error:', error);
    throw new InternalError('Failed to update comment');
  }

  return {
    ...updated,
    user: updated.user,
  } as Comment;
}

/**
 * Delete comment
 */
export async function deleteComment(
  supabase: SupabaseClient,
  commentId: string,
  userId: string
): Promise<void> {
  // Get comment
  const { data: comment } = await supabase
    .from('comments')
    .select('user_id')
    .eq('id', commentId)
    .single();

  if (!comment) {
    throw new NotFoundError('Comment');
  }

  // Only author can delete
  if (comment.user_id !== userId) {
    throw new ForbiddenError('You can only delete your own comments');
  }

  const { error } = await supabase.from('comments').delete().eq('id', commentId);

  if (error) {
    console.error('Comment deletion error:', error);
    throw new InternalError('Failed to delete comment');
  }
}

/**
 * Get comments for a check-in
 */
export async function getCheckInComments(
  supabase: SupabaseClient,
  checkInId: string
): Promise<Comment[]> {
  const { data: comments, error } = await supabase
    .from('comments')
    .select('*, user:users(username, display_name, avatar_url)')
    .eq('check_in_id', checkInId)
    .order('created_at', { ascending: true });

  if (error) {
    console.error('Comments fetch error:', error);
    return [];
  }

  return (comments || []).map((c) => ({
    ...c,
    user: c.user,
  })) as Comment[];
}

/**
 * Create feed event
 */
export async function createFeedEvent(
  supabase: SupabaseClient,
  input: CreateFeedEventInput
): Promise<FeedEvent> {
  const visibility = input.visibility || determineFeedEventVisibility(input.type);

  const { data: feedEvent, error } = await supabase
    .from('feed_events')
    .insert({
      user_id: input.user_id,
      pack_id: input.pack_id,
      type: input.type,
      reference_id: input.reference_id,
      visibility,
      metadata: input.metadata,
    })
    .select('*, user:users(username, display_name, avatar_url)')
    .single();

  if (error || !feedEvent) {
    console.error('Feed event creation error:', error);
    throw new InternalError('Failed to create feed event');
  }

  return {
    ...feedEvent,
    user: feedEvent.user,
  } as FeedEvent;
}

/**
 * Get feed events for user's packs
 */
export async function getFeedEvents(
  supabase: SupabaseClient,
  userId: string,
  limit: number = 20,
  offset: number = 0
): Promise<FeedEvent[]> {
  // Get user's pack IDs
  const { data: memberships } = await supabase
    .from('pack_members')
    .select('pack_id')
    .eq('user_id', userId);

  if (!memberships || memberships.length === 0) {
    return [];
  }

  const packIds = memberships.map((m) => m.pack_id);

  // Get feed events
  const { data: events, error } = await supabase
    .from('feed_events')
    .select('*, user:users(username, display_name, avatar_url)')
    .in('pack_id', packIds)
    .in('visibility', ['pack', 'public'])
    .order('created_at', { ascending: false })
    .range(offset, offset + limit - 1);

  if (error) {
    console.error('Feed events fetch error:', error);
    return [];
  }

  return (events || []).map((e) => ({
    ...e,
    user: e.user,
  })) as FeedEvent[];
}
