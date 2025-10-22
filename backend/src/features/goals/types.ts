/**
 * Recurrence rule types
 */
export type RecurrenceType = 'daily' | 'weekly' | 'custom';

/**
 * Recurrence rule structure
 */
export interface RecurrenceRule {
  type: RecurrenceType;
  interval: number; // Every N days/weeks
  days_of_week?: number[]; // 0-6 (Sunday-Saturday) for weekly
  end_date?: string; // Optional end date for recurring goals
}

/**
 * Goal data structure
 */
export interface Goal {
  id: string;
  pack_id: string;
  user_id: string;
  title: string;
  description?: string;
  check_in_time: string; // HH:MM format (24-hour)
  recurrence_rule: RecurrenceRule;
  fine_amount: number; // In cents
  jail_duration: number; // In minutes
  proof_required: boolean;
  is_active: boolean;
  base_xp: number;
  created_at: string;
  updated_at: string;
  user?: {
    username: string;
    display_name?: string;
    avatar_url?: string;
  };
}

/**
 * Input for creating a new goal
 */
export interface CreateGoalInput {
  title: string;
  description?: string;
  check_in_time: string;
  recurrence_rule: RecurrenceRule;
  fine_amount?: number;
  jail_duration?: number;
  proof_required?: boolean;
  base_xp?: number;
}

/**
 * Input for updating a goal
 */
export interface UpdateGoalInput {
  title?: string;
  description?: string;
  check_in_time?: string;
  recurrence_rule?: RecurrenceRule;
  fine_amount?: number;
  jail_duration?: number;
  proof_required?: boolean;
  base_xp?: number;
}

/**
 * Goal with statistics
 */
export interface GoalWithStats extends Goal {
  total_checkins: number;
  completion_rate: number;
  current_streak: number;
  longest_streak: number;
}
