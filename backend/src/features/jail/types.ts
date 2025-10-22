/**
 * Phone jail session data structure
 */
export interface PhoneJail {
  id: string;
  user_id: string;
  pack_id: string;
  goal_id: string;
  fine_id?: string;
  duration_minutes: number;
  blocked_apps: string[]; // iOS bundle IDs
  status: 'active' | 'completed' | 'broken';
  started_at: string;
  last_heartbeat_at?: string;
  paused_at?: string;
  total_paused_duration: number; // In seconds
  completed_at?: string;
  created_at: string;
  updated_at: string;
  user?: {
    username: string;
    display_name?: string;
    avatar_url?: string;
  };
  goal?: {
    title: string;
  };
}

/**
 * Jail session with progress calculation
 */
export interface JailSessionWithProgress extends PhoneJail {
  elapsed_minutes: number;
  remaining_minutes: number;
  progress_percentage: number;
  is_paused: boolean;
  can_break: boolean;
  break_fine_amount: number;
}

/**
 * Input for starting jail
 */
export interface StartJailInput {
  goal_id: string;
  fine_id?: string;
  duration_minutes?: number;
  blocked_apps: string[];
}

/**
 * Heartbeat input
 */
export interface HeartbeatInput {
  timestamp?: string; // Optional client timestamp
}

/**
 * Break jail input
 */
export interface BreakJailInput {
  payment_method?: string;
}

/**
 * Jail completion result
 */
export interface JailCompletion {
  session: PhoneJail;
  feed_event_created: boolean;
  punishment_updated: boolean;
}
