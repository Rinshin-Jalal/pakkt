import type { StreakResult, XPAward } from './types';

/**
 * Calculate XP award with streak bonus
 * Formula: base_xp * (1 + streak_count * 0.1)
 * Example: 100 base + 5 day streak = 150 XP total
 */
export function calculateXPAward(
  baseXP: number,
  streakCount: number,
  currentUserXP: number = 0
): XPAward {
  const streakBonus = Math.floor(baseXP * streakCount * 0.1);
  const totalXP = baseXP + streakBonus;
  
  // Calculate level before and after
  const oldLevel = calculateLevelFromXP(currentUserXP);
  const newTotalXP = currentUserXP + totalXP;
  const newLevel = calculateLevelFromXP(newTotalXP);
  
  return {
    base_xp: baseXP,
    streak_bonus: streakBonus,
    total_xp: totalXP,
    new_level: newLevel !== oldLevel ? newLevel : undefined,
    leveled_up: newLevel > oldLevel,
  };
}

/**
 * Calculate level from total XP
 * Level 1: 0 XP
 * Level 2: 100 XP
 * Level 3: 300 XP (100 + 200)
 * Level 4: 600 XP (300 + 300)
 * Formula: level_n requires sum of (i * 100) for i=1 to n-1
 */
export function calculateLevelFromXP(xp: number): number {
  if (xp < 0) return 1;
  
  let level = 1;
  let xpRequired = 0;
  
  while (xpRequired <= xp) {
    level++;
    xpRequired += level * 100;
  }
  
  return level - 1;
}

/**
 * Calculate streak count based on previous check-ins
 * Returns streak information
 */
export function calculateStreak(
  previousCheckIns: Array<{ created_at: string }>,
  currentDate: Date = new Date()
): StreakResult {
  if (!previousCheckIns || previousCheckIns.length === 0) {
    return {
      streak_count: 1,
      is_new_streak: true,
      streak_broken: false,
      previous_streak: 0,
    };
  }

  // Sort by date descending
  const sorted = [...previousCheckIns].sort(
    (a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
  );

  const lastCheckIn = new Date(sorted[0].created_at);
  lastCheckIn.setHours(0, 0, 0, 0);
  
  const today = new Date(currentDate);
  today.setHours(0, 0, 0, 0);
  
  const yesterday = new Date(today);
  yesterday.setDate(yesterday.getDate() - 1);

  // Calculate days between last check-in and today
  const daysDiff = Math.floor(
    (today.getTime() - lastCheckIn.getTime()) / (1000 * 60 * 60 * 24)
  );

  // Already checked in today - shouldn't happen due to duplicate prevention
  if (daysDiff === 0) {
    return {
      streak_count: 1,
      is_new_streak: false,
      streak_broken: false,
      previous_streak: 1,
    };
  }

  // Checked in yesterday - continue streak
  if (daysDiff === 1) {
    let streakCount = 1;
    let checkDate = new Date(lastCheckIn);

    // Count consecutive days
    for (let i = 0; i < sorted.length - 1; i++) {
      const current = new Date(sorted[i].created_at);
      current.setHours(0, 0, 0, 0);

      const next = new Date(sorted[i + 1].created_at);
      next.setHours(0, 0, 0, 0);

      const diff = Math.floor(
        (current.getTime() - next.getTime()) / (1000 * 60 * 60 * 24)
      );

      if (diff === 1) {
        streakCount++;
      } else {
        break;
      }
    }

    return {
      streak_count: streakCount + 1, // +1 for today
      is_new_streak: false,
      streak_broken: false,
      previous_streak: streakCount,
    };
  }

  // Streak broken (missed more than 1 day)
  return {
    streak_count: 1,
    is_new_streak: true,
    streak_broken: true,
    previous_streak: 0,
  };
}

/**
 * Check if user already checked in for this goal today
 */
export function hasCheckedInToday(
  checkIns: Array<{ created_at: string }>,
  currentDate: Date = new Date()
): boolean {
  if (!checkIns || checkIns.length === 0) {
    return false;
  }

  const today = new Date(currentDate);
  today.setHours(0, 0, 0, 0);

  return checkIns.some((checkIn) => {
    const checkInDate = new Date(checkIn.created_at);
    checkInDate.setHours(0, 0, 0, 0);
    return checkInDate.getTime() === today.getTime();
  });
}

/**
 * Determine check-in status based on goal time and current time
 */
export function determineCheckInStatus(
  goalCheckInTime: string,
  currentTime: Date = new Date()
): 'success' | 'missed' | 'pending_vote' {
  // Parse goal check-in time
  const [hours, minutes] = goalCheckInTime.split(':').map(Number);
  const goalTime = new Date(currentTime);
  goalTime.setHours(hours, minutes, 0, 0);

  // 30-minute window before and after
  const windowStart = new Date(goalTime);
  windowStart.setMinutes(windowStart.getMinutes() - 30);

  const windowEnd = new Date(goalTime);
  windowEnd.setMinutes(windowEnd.getMinutes() + 30);

  // Check if within window
  if (currentTime >= windowStart && currentTime <= windowEnd) {
    return 'success';
  }

  // Check if late (after window) - needs voting
  if (currentTime > windowEnd) {
    return 'pending_vote';
  }

  // Too early - also needs voting
  return 'pending_vote';
}

/**
 * Calculate success rate percentage
 */
export function calculateSuccessRate(
  successfulCheckIns: number,
  totalExpectedCheckIns: number
): number {
  if (totalExpectedCheckIns === 0) return 0;
  return Math.min(100, Math.round((successfulCheckIns / totalExpectedCheckIns) * 100));
}

/**
 * Get date range for filtering
 */
export function getDateRange(period: 'today' | 'week' | 'month'): {
  start: Date;
  end: Date;
} {
  const end = new Date();
  const start = new Date();

  switch (period) {
    case 'today':
      start.setHours(0, 0, 0, 0);
      end.setHours(23, 59, 59, 999);
      break;
    case 'week':
      start.setDate(start.getDate() - 7);
      start.setHours(0, 0, 0, 0);
      break;
    case 'month':
      start.setDate(start.getDate() - 30);
      start.setHours(0, 0, 0, 0);
      break;
  }

  return { start, end };
}
