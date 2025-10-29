import { NotificationType, NotificationContext } from './types';

/**
 * Notification template
 */
interface NotificationTemplate {
  title: string;
  body: string;
  category?: string;
  sound?: string;
  badge?: number;
  data?: Record<string, any>;
}

/**
 * Generate notification content from template
 */
export function getNotificationTemplate(
  type: NotificationType,
  context: NotificationContext
): NotificationTemplate {
  switch (type) {
    // ========================================
    // CHECK-IN EVENTS
    // ========================================
    case NotificationType.NEW_CHECK_IN:
      return {
        title: `${context.username} checked in! 🔥`,
        body: context.goalTitle || 'New check-in completed',
        category: 'CHECK_IN',
        data: {
          type: 'check_in',
          id: context.checkInId,
          pack_id: context.packId,
        },
      };

    case NotificationType.CHECK_IN_REMINDER:
      return {
        title: 'Time to check in! ⏰',
        body: context.goalTitle || 'Don\'t break your streak',
        category: 'CHECK_IN_REMINDER',
        sound: 'reminder.caf',
        data: {
          type: 'goal',
          id: context.goalId,
        },
      };

    case NotificationType.STREAK_MILESTONE:
      return {
        title: `${context.streakCount} day streak! 🔥`,
        body: `You're on fire! Keep up the momentum.`,
        category: 'ACHIEVEMENT',
        sound: 'achievement.caf',
        data: {
          type: 'streak',
          count: context.streakCount,
        },
      };

    // ========================================
    // FINE EVENTS
    // ========================================
    case NotificationType.FINE_CREATED:
      return {
        title: `Fine Issued: $${(context.amount || 0) / 100}`,
        body: `${context.username} missed a check-in. Vote now!`,
        category: 'FINE_VOTE',
        data: {
          type: 'fine',
          id: context.fineId,
          pack_id: context.packId,
        },
      };

    case NotificationType.FINE_VOTE_NEEDED:
      return {
        title: 'Your vote is needed 🗳️',
        body: `Fine for ${context.username}: $${(context.amount || 0) / 100}`,
        category: 'FINE_VOTE',
        data: {
          type: 'fine',
          id: context.fineId,
          pack_id: context.packId,
        },
      };

    case NotificationType.FINE_RESOLVED:
      return {
        title: context.enforced ? 'Fine Enforced' : 'Fine Dismissed',
        body: context.enforced
          ? `Pack voted to enforce the $${(context.amount || 0) / 100} fine`
          : 'Pack voted to dismiss the fine',
        category: 'FINE_RESULT',
        data: {
          type: 'fine',
          id: context.fineId,
          enforced: context.enforced,
        },
      };

    case NotificationType.FINE_APPEALED:
      return {
        title: 'Fine Appeal',
        body: `${context.username} appealed a fine decision`,
        category: 'FINE_APPEAL',
        data: {
          type: 'fine',
          id: context.fineId,
        },
      };

    // ========================================
    // SOCIAL EVENTS
    // ========================================
    case NotificationType.NEW_COMMENT:
      return {
        title: `${context.username} commented 💬`,
        body: context.commentText || 'New comment on your check-in',
        category: 'COMMENT',
        data: {
          type: 'check_in',
          id: context.checkInId,
        },
      };

    case NotificationType.NEW_REACTION:
      return {
        title: `${context.username} reacted ${context.emoji}`,
        body: context.goalTitle || 'Someone liked your check-in',
        category: 'REACTION',
        data: {
          type: 'check_in',
          id: context.checkInId,
        },
      };

    case NotificationType.COMMENT_MENTION:
      return {
        title: `${context.username} mentioned you`,
        body: context.commentText || 'You were mentioned in a comment',
        category: 'MENTION',
        data: {
          type: 'check_in',
          id: context.checkInId,
        },
      };

    // ========================================
    // PACK EVENTS
    // ========================================
    case NotificationType.NEW_PACK_MEMBER:
      return {
        title: 'New Pack Member! 🎉',
        body: `${context.username} joined ${context.packName}`,
        category: 'PACK',
        data: {
          type: 'pack',
          id: context.packId,
        },
      };

    case NotificationType.PACK_INVITATION:
      return {
        title: 'Pack Invitation',
        body: `${context.username} invited you to join ${context.packName}`,
        category: 'PACK_INVITE',
        data: {
          type: 'pack',
          id: context.packId,
          invite_code: context.inviteCode,
        },
      };

    // ========================================
    // JAIL EVENTS
    // ========================================
    case NotificationType.JAIL_STARTED:
      return {
        title: 'Jail Session Started ⏱️',
        body: `${context.duration} minutes of focused time`,
        category: 'JAIL',
        data: {
          type: 'jail',
          id: context.jailSessionId,
        },
      };

    case NotificationType.JAIL_COMPLETED:
      return {
        title: 'Jail Completed! 🎉',
        body: 'Great job staying focused!',
        category: 'JAIL_COMPLETE',
        sound: 'achievement.caf',
        data: {
          type: 'jail',
          id: context.jailSessionId,
        },
      };

    case NotificationType.JAIL_BROKEN:
      return {
        title: 'Jail Session Broken',
        body: `Fine: $${(context.breakFine || 0) / 100}`,
        category: 'JAIL_BROKEN',
        data: {
          type: 'jail',
          id: context.jailSessionId,
        },
      };

    // ========================================
    // SYSTEM EVENTS
    // ========================================
    case NotificationType.LEVEL_UP:
      return {
        title: `Level ${context.level} Unlocked! 🎊`,
        body: `You've reached level ${context.level}`,
        category: 'LEVEL_UP',
        sound: 'achievement.caf',
        badge: context.level,
        data: {
          type: 'level',
          level: context.level,
        },
      };

    case NotificationType.ACHIEVEMENT_UNLOCKED:
      return {
        title: 'Achievement Unlocked! 🏆',
        body: context.achievementName || 'New achievement earned',
        category: 'ACHIEVEMENT',
        sound: 'achievement.caf',
        data: {
          type: 'achievement',
          id: context.achievementId,
        },
      };

    default:
      return {
        title: 'Pakkt',
        body: 'You have a new notification',
        category: 'GENERAL',
      };
  }
}
