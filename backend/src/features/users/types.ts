/**
 * User profile data structure
 */
export interface UserProfile {
  id: string;
  phone_number?: string;
  email?: string;
  username: string;
  profile_pic?: string;
  bio?: string;
  subscription_status: 'free' | 'trial' | 'pro';
  subscription_expires_at?: string;
  total_xp: number;
  current_level: number;
  current_streak: number;
  longest_streak: number;
  total_checkins: number;
  total_fines_paid: number;
  total_jails_completed: number;
  created_at: string;
  updated_at: string;
}

/**
 * Input for updating user profile
 */
export interface UpdateProfileInput {
  username?: string;
  profile_pic?: string;
  bio?: string;
}

/**
 * Push notification token registration
 */
export interface PushTokenInput {
  token: string;
  device_type: 'ios' | 'android';
  device_id?: string;
}

/**
 * Push token record
 */
export interface PushToken {
  id: string;
  user_id: string;
  token: string;
  device_type: 'ios' | 'android';
  device_id?: string;
  created_at: string;
  updated_at: string;
}
