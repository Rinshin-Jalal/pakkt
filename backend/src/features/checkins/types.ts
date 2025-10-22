/**
 * Check-in data structure
 */
export interface CheckIn {
  id: string;
  goal_id: string;
  user_id: string;
  pack_id: string;
  proof_url?: string;
  caption?: string;
  status: 'pending' | 'verified' | 'late' | 'missed';
  streak_count: number;
  xp_awarded: number;
  checked_in_at: string;
  created_at: string;
  goal?: {
    title: string;
    base_xp: number;
  };
  user?: {
    username: string;
    display_name?: string;
    avatar_url?: string;
  };
}

/**
 * Feed item (check-in with additional context)
 */
export interface FeedItem extends CheckIn {
  reactions_count?: number;
  comments_count?: number;
}

/**
 * Input for creating a check-in
 */
export interface CreateCheckInInput {
  goal_id: string;
  proof_url?: string;
  caption?: string;
}

/**
 * Streak calculation result
 */
export interface StreakResult {
  streak_count: number;
  is_new_streak: boolean;
  streak_broken: boolean;
  previous_streak: number;
}

/**
 * XP award calculation result
 */
export interface XPAward {
  base_xp: number;
  streak_bonus: number;
  total_xp: number;
  new_level?: number;
  leveled_up: boolean;
}

/**
 * Check-in statistics
 */
export interface CheckInStats {
  total_checkins: number;
  current_streak: number;
  longest_streak: number;
  total_xp_earned: number;
  success_rate: number;
  this_week: number;
  this_month: number;
}
