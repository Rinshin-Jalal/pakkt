import type { RecurrenceRule } from './types';

/**
 * Day names for display
 */
const DAY_NAMES = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

/**
 * Format recurrence rule as human-readable string
 */
export function formatRecurrenceRule(rule: RecurrenceRule): string {
  switch (rule.type) {
    case 'daily':
      if (rule.interval === 1) {
        return 'Every day';
      }
      return `Every ${rule.interval} days`;

    case 'weekly':
      if (!rule.days_of_week || rule.days_of_week.length === 0) {
        return 'Weekly';
      }
      
      const dayNames = rule.days_of_week
        .sort((a, b) => a - b)
        .map((day) => DAY_NAMES[day]);
      
      if (rule.interval === 1) {
        if (dayNames.length === 7) {
          return 'Every day';
        }
        return `Every ${dayNames.join(', ')}`;
      }
      
      return `Every ${rule.interval} weeks on ${dayNames.join(', ')}`;

    case 'custom':
      return `Every ${rule.interval} days`;

    default:
      return 'Custom schedule';
  }
}

/**
 * Check if goal should occur on a given date
 */
export function shouldOccurOnDate(
  rule: RecurrenceRule,
  date: Date,
  goalCreatedAt: Date
): boolean {
  const dayOfWeek = date.getDay();
  const daysSinceCreation = Math.floor(
    (date.getTime() - goalCreatedAt.getTime()) / (1000 * 60 * 60 * 24)
  );

  switch (rule.type) {
    case 'daily':
      return daysSinceCreation % rule.interval === 0;

    case 'weekly':
      if (!rule.days_of_week || rule.days_of_week.length === 0) {
        return false;
      }
      
      // Check if today is one of the selected days
      if (!rule.days_of_week.includes(dayOfWeek)) {
        return false;
      }
      
      // Check interval (which week)
      const weeksSinceCreation = Math.floor(daysSinceCreation / 7);
      return weeksSinceCreation % rule.interval === 0;

    case 'custom':
      return daysSinceCreation % rule.interval === 0;

    default:
      return false;
  }
}

/**
 * Get next occurrence date for a goal
 */
export function getNextOccurrence(
  rule: RecurrenceRule,
  currentDate: Date,
  goalCreatedAt: Date
): Date | null {
  const maxDaysToCheck = 90; // Look ahead up to 90 days
  let checkDate = new Date(currentDate);
  checkDate.setDate(checkDate.getDate() + 1); // Start from tomorrow

  for (let i = 0; i < maxDaysToCheck; i++) {
    if (shouldOccurOnDate(rule, checkDate, goalCreatedAt)) {
      return checkDate;
    }
    checkDate.setDate(checkDate.getDate() + 1);
  }

  return null; // No occurrence found in next 90 days
}

/**
 * Validate time format and return Date object for today at that time
 */
export function parseCheckInTime(timeString: string): Date | null {
  const match = timeString.match(/^(\d{1,2}):(\d{2})$/);
  if (!match) {
    return null;
  }

  const hours = parseInt(match[1], 10);
  const minutes = parseInt(match[2], 10);

  if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
    return null;
  }

  const date = new Date();
  date.setHours(hours, minutes, 0, 0);
  return date;
}

/**
 * Calculate check-in window (30 minutes before and after check-in time)
 */
export function getCheckInWindow(checkInTime: string): {
  start: Date;
  end: Date;
} | null {
  const time = parseCheckInTime(checkInTime);
  if (!time) {
    return null;
  }

  const start = new Date(time);
  start.setMinutes(start.getMinutes() - 30);

  const end = new Date(time);
  end.setMinutes(end.getMinutes() + 30);

  return { start, end };
}

/**
 * Check if current time is within check-in window
 */
export function isWithinCheckInWindow(checkInTime: string): boolean {
  const window = getCheckInWindow(checkInTime);
  if (!window) {
    return false;
  }

  const now = new Date();
  return now >= window.start && now <= window.end;
}

/**
 * Get goals that are due today for a user
 */
export function filterGoalsDueToday(
  goals: Array<{ recurrence_rule: RecurrenceRule; created_at: string }>
): Array<number> {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  return goals
    .map((goal, index) => {
      const createdAt = new Date(goal.created_at);
      return shouldOccurOnDate(goal.recurrence_rule, today, createdAt) ? index : -1;
    })
    .filter((index) => index !== -1);
}
