import type { Reaction, ReactionCounts, EmojiType, FeedEventType } from './types';

/**
 * Group reactions by emoji and count
 */
export function groupReactionsByEmoji(
  reactions: Reaction[],
  currentUserId?: string
): ReactionCounts {
  const grouped: ReactionCounts = {};

  for (const reaction of reactions) {
    const emoji = reaction.emoji;

    if (!grouped[emoji]) {
      grouped[emoji] = {
        count: 0,
        users: [],
        user_reacted: false,
      };
    }

    grouped[emoji].count++;
    grouped[emoji].users.push(reaction.user_id);

    if (currentUserId && reaction.user_id === currentUserId) {
      grouped[emoji].user_reacted = true;
    }
  }

  return grouped;
}

/**
 * Check if user can edit comment (within 5 minutes)
 */
export function canEditComment(createdAt: string): boolean {
  const created = new Date(createdAt).getTime();
  const now = Date.now();
  const minutesElapsed = (now - created) / (1000 * 60);

  return minutesElapsed <= 5;
}

/**
 * Validate emoji is supported
 */
export function isValidEmoji(emoji: string): emoji is EmojiType {
  const supportedEmojis: EmojiType[] = ['🔥', '💪', '👏', '🎉', '😂', '❤️', '👀'];
  return supportedEmojis.includes(emoji as EmojiType);
}

/**
 * Get emoji name for display
 */
export function getEmojiName(emoji: EmojiType): string {
  const names: Record<EmojiType, string> = {
    '🔥': 'fire',
    '💪': 'strong',
    '👏': 'clap',
    '🎉': 'party',
    '😂': 'laugh',
    '❤️': 'heart',
    '👀': 'eyes',
  };
  return names[emoji] || 'unknown';
}

/**
 * Generate feed event message based on type
 */
export function generateFeedEventMessage(
  type: FeedEventType,
  metadata?: any
): string {
  switch (type) {
    case 'checkin_success':
      return `Checked in for "${metadata?.goal_title || 'goal'}"`;

    case 'fine_voted':
      if (metadata?.result === 'enforced') {
        return 'Fine was enforced by pack vote';
      }
      return 'Fine was dismissed by pack vote';

    case 'jail_served':
      const duration = metadata?.duration_minutes || 0;
      return `Served ${duration} minutes in phone jail`;

    case 'level_up':
      return `Reached level ${metadata?.new_level || '?'}!`;

    case 'pack_milestone':
      return `Pack reached ${metadata?.milestone || 'milestone'}!`;

    default:
      return 'Activity';
  }
}

/**
 * Determine visibility for feed event
 */
export function determineFeedEventVisibility(
  type: FeedEventType,
  checkInVisibility?: string
): 'private' | 'pack' | 'public' {
  // Check-in success inherits check-in visibility
  if (type === 'checkin_success' && checkInVisibility) {
    return checkInVisibility as 'private' | 'pack' | 'public';
  }

  // Fines and jail are pack-visible by default
  if (type === 'fine_voted' || type === 'jail_served') {
    return 'pack';
  }

  // Level ups are pack-visible
  if (type === 'level_up') {
    return 'pack';
  }

  // Pack milestones are pack-visible
  if (type === 'pack_milestone') {
    return 'pack';
  }

  // Default to pack visibility
  return 'pack';
}

/**
 * Check if user has already reacted to an item
 */
export function hasUserReacted(
  reactions: Reaction[],
  userId: string,
  emoji?: EmojiType
): Reaction | undefined {
  return reactions.find((r) => {
    if (emoji) {
      return r.user_id === userId && r.emoji === emoji;
    }
    return r.user_id === userId;
  });
}

/**
 * Sort reactions by creation date
 */
export function sortReactions(reactions: Reaction[]): Reaction[] {
  return reactions.sort((a, b) => {
    return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
  });
}

/**
 * Sort comments by creation date
 */
export function sortComments(comments: any[]): any[] {
  return comments.sort((a, b) => {
    return new Date(a.created_at).getTime() - new Date(b.created_at).getTime();
  });
}

/**
 * Get most popular emoji from reactions
 */
export function getMostPopularEmoji(reactions: Reaction[]): EmojiType | null {
  if (reactions.length === 0) return null;

  const counts = groupReactionsByEmoji(reactions);
  let maxCount = 0;
  let topEmoji: EmojiType | null = null;

  for (const [emoji, data] of Object.entries(counts)) {
    if (data.count > maxCount) {
      maxCount = data.count;
      topEmoji = emoji as EmojiType;
    }
  }

  return topEmoji;
}

/**
 * Calculate engagement score (reactions + comments)
 */
export function calculateEngagementScore(
  reactionCount: number,
  commentCount: number
): number {
  return reactionCount + commentCount * 2; // Comments worth 2x reactions
}
