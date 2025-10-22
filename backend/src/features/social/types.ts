/**
 * Supported emoji reactions
 */
export type EmojiType = '🔥' | '💪' | '👏' | '🎉' | '😂' | '❤️' | '👀';

/**
 * Reaction data structure
 */
export interface Reaction {
  id: string;
  user_id: string;
  check_in_id?: string;
  feed_event_id?: string;
  emoji: EmojiType;
  created_at: string;
  updated_at: string;
  user?: {
    username: string;
    display_name?: string;
    avatar_url?: string;
  };
}

/**
 * Reaction counts grouped by emoji
 */
export interface ReactionCounts {
  [emoji: string]: {
    count: number;
    users: string[]; // User IDs who reacted with this emoji
    user_reacted: boolean; // Did current user react with this?
  };
}

/**
 * Comment data structure
 */
export interface Comment {
  id: string;
  check_in_id: string;
  user_id: string;
  content: string;
  edited: boolean;
  created_at: string;
  updated_at: string;
  user?: {
    username: string;
    display_name?: string;
    avatar_url?: string;
  };
}

/**
 * Feed event types
 */
export type FeedEventType =
  | 'checkin_success'
  | 'fine_voted'
  | 'jail_served'
  | 'level_up'
  | 'pack_milestone';

/**
 * Feed event data structure
 */
export interface FeedEvent {
  id: string;
  user_id: string;
  pack_id: string;
  type: FeedEventType;
  reference_id?: string; // ID of related object (check-in, fine, etc.)
  visibility: 'private' | 'pack' | 'public';
  metadata?: any;
  created_at: string;
  user?: {
    username: string;
    display_name?: string;
    avatar_url?: string;
  };
}

/**
 * Input for creating a reaction
 */
export interface CreateReactionInput {
  check_in_id?: string;
  feed_event_id?: string;
  emoji: EmojiType;
}

/**
 * Input for creating a comment
 */
export interface CreateCommentInput {
  check_in_id: string;
  content: string;
}

/**
 * Input for editing a comment
 */
export interface EditCommentInput {
  content: string;
}

/**
 * Feed event creation input
 */
export interface CreateFeedEventInput {
  user_id: string;
  pack_id: string;
  type: FeedEventType;
  reference_id?: string;
  visibility?: 'private' | 'pack' | 'public';
  metadata?: any;
}
