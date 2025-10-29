/**
 * Notification event types
 */
export enum NotificationType {
  // Check-in events
  NEW_CHECK_IN = 'new_check_in',
  CHECK_IN_REMINDER = 'check_in_reminder',
  STREAK_MILESTONE = 'streak_milestone',

  // Fine events
  FINE_CREATED = 'fine_created',
  FINE_VOTE_NEEDED = 'fine_vote_needed',
  FINE_RESOLVED = 'fine_resolved',
  FINE_APPEALED = 'fine_appealed',

  // Social events
  NEW_COMMENT = 'new_comment',
  NEW_REACTION = 'new_reaction',
  COMMENT_MENTION = 'comment_mention',

  // Pack events
  NEW_PACK_MEMBER = 'new_pack_member',
  PACK_INVITATION = 'pack_invitation',

  // Jail events
  JAIL_STARTED = 'jail_started',
  JAIL_COMPLETED = 'jail_completed',
  JAIL_BROKEN = 'jail_broken',

  // System events
  LEVEL_UP = 'level_up',
  ACHIEVEMENT_UNLOCKED = 'achievement_unlocked',
}

/**
 * Notification payload data
 */
export interface NotificationData {
  type: NotificationType;
  userId: string;
  packId?: string;
  [key: string]: any;
}

/**
 * Notification recipients
 */
export interface NotificationRecipient {
  userId: string;
  tokens: string[];
}

/**
 * Notification context for templates
 */
export interface NotificationContext {
  username?: string;
  packName?: string;
  goalTitle?: string;
  amount?: number;
  streakCount?: number;
  commentText?: string;
  [key: string]: any;
}
