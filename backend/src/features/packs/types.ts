/**
 * Pack data structure
 */
export interface Pack {
  id: string;
  name: string;
  creator_id: string;
  xp: number;
  level: number;
  goal_type?: string;
  status: 'active' | 'dissolved';
  created_at: string;
  updated_at?: string;
  last_activity?: string;
}

/**
 * Pack member data structure
 */
export interface PackMember {
  id: string;
  pack_id: string;
  user_id: string;
  role: 'admin' | 'member';
  join_date: string;
  reputation_xp: number;
  is_active: boolean;
  created_at?: string;
  updated_at?: string;
  user?: {
    username: string;
    display_name?: string;
    avatar_url?: string;
  };
}

/**
 * Pack statistics
 */
export interface PackStats {
  pack_id: string;
  total_xp: number;
  current_level: number;
  member_count: number;
  total_checkins: number;
  total_fines: number;
  total_jails: number;
  average_streak: number;
  top_performers: Array<{
    user_id: string;
    username: string;
    xp: number;
    streak: number;
  }>;
}

/**
 * Input for creating a new pack
 */
export interface CreatePackInput {
  name: string;
  goal_type?: string;
}

/**
 * Input for updating a pack
 */
export interface UpdatePackInput {
  name?: string;
  description?: string;
  visibility?: 'private' | 'pack' | 'public';
  default_fine_amount?: number;
  default_jail_duration?: number;
}

/**
 * Input for adding a member
 */
export interface AddMemberInput {
  user_id?: string;
  invite_code?: string;
}
