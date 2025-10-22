import { SupabaseClient } from '@supabase/supabase-js';
import {
  NotFoundError,
  InternalError,
  ConflictError,
  ValidationError,
  ForbiddenError,
} from '../../lib/errors';
import type {
  CheckIn,
  FeedItem,
  CreateCheckInInput,
  CheckInStats,
} from './types';
import {
  calculateXPAward,
  calculateStreak,
  hasCheckedInToday,
  determineCheckInStatus,
  calculateSuccessRate,
  getDateRange,
  calculateLevelFromXP,
} from './utils';

/**
 * Create a check-in for a goal
 */
export async function createCheckIn(
  supabase: SupabaseClient,
  userId: string,
  input: CreateCheckInInput
): Promise<CheckIn> {
  // Get goal details
  const { data: goal, error: goalError } = await supabase
    .from('goals')
    .select('*, packs(default_fine_amount)')
    .eq('id', input.goal_id)
    .single();

  if (goalError || !goal) {
    throw new NotFoundError('Goal');
  }

  // Verify goal is active
  if (!goal.is_active) {
    throw new ValidationError('Goal is not active');
  }

  // Check if proof is required
  if (goal.proof_required && !input.proof_url) {
    throw new ValidationError('Proof URL is required for this goal');
  }

  // Check for duplicate check-in today
  const { data: todayCheckIns } = await supabase
    .from('check_ins')
    .select('checked_in_at')
    .eq('goal_id', input.goal_id)
    .eq('user_id', userId)
    .gte('checked_in_at', new Date().toISOString().split('T')[0]); // Today

  if (hasCheckedInToday(todayCheckIns || [])) {
    throw new ConflictError('You have already checked in for this goal today');
  }

  // Get previous check-ins for streak calculation
  const { data: previousCheckIns } = await supabase
    .from('check_ins')
    .select('checked_in_at, streak_count')
    .eq('goal_id', input.goal_id)
    .eq('user_id', userId)
    .order('checked_in_at', { ascending: false })
    .limit(30);

  // Calculate streak
  const streakResult = calculateStreak(previousCheckIns || []);

  // Get user's current XP
  const { data: user } = await supabase
    .from('users')
    .select('total_xp, current_level')
    .eq('id', userId)
    .single();

  // Calculate XP award
  const xpAward = calculateXPAward(
    goal.base_xp,
    streakResult.streak_count,
    user?.total_xp || 0
  );

  // Determine status
  const status = determineCheckInStatus(goal.check_in_time);

  // Create check-in
  const { data: checkIn, error } = await supabase
    .from('check_ins')
    .insert({
      goal_id: input.goal_id,
      user_id: userId,
      pack_id: goal.pack_id,
      proof_url: input.proof_url,
      caption: input.caption,
      status,
      streak_count: streakResult.streak_count,
      xp_awarded: xpAward.total_xp,
      checked_in_at: new Date().toISOString(),
    })
    .select(
      '*, goal:goals(title, base_xp), user:users(username, display_name, avatar_url)'
    )
    .single();

  if (error || !checkIn) {
    console.error('Check-in creation error:', error);
    throw new InternalError('Failed to create check-in');
  }

  // Update user stats
  await supabase
    .from('users')
    .update({
      total_xp: (user?.total_xp || 0) + xpAward.total_xp,
      current_level: xpAward.new_level || user?.current_level || 1,
      current_streak: streakResult.streak_count,
      longest_streak: Math.max(
        streakResult.streak_count,
        user?.longest_streak || 0
      ),
      total_checkins: (user?.total_checkins || 0) + 1,
    })
    .eq('id', userId);

  // Update pack member stats
  await supabase.rpc('increment_pack_member_xp', {
    p_pack_id: goal.pack_id,
    p_user_id: userId,
    p_xp_amount: xpAward.total_xp,
    p_streak: streakResult.streak_count,
  });

  // Update pack total XP and level
  const { data: packMembers } = await supabase
    .from('pack_members')
    .select('total_xp')
    .eq('pack_id', goal.pack_id);

  if (packMembers) {
    const totalPackXP = packMembers.reduce((sum, m) => sum + (m.total_xp || 0), 0);
    const packLevel = calculateLevelFromXP(totalPackXP);

    await supabase
      .from('packs')
      .update({
        total_xp: totalPackXP,
        current_level: packLevel,
      })
      .eq('id', goal.pack_id);
  }

  return {
    ...checkIn,
    goal: checkIn.goal,
    user: checkIn.user,
  } as CheckIn;
}

/**
 * Get feed of check-ins across user's packs
 */
export async function getFeed(
  supabase: SupabaseClient,
  userId: string,
  filters?: {
    pack_id?: string;
    limit?: number;
    offset?: number;
  }
): Promise<FeedItem[]> {
  // Get user's pack IDs
  const { data: memberships } = await supabase
    .from('pack_members')
    .select('pack_id')
    .eq('user_id', userId);

  if (!memberships || memberships.length === 0) {
    return [];
  }

  const packIds = filters?.pack_id
    ? [filters.pack_id]
    : memberships.map((m) => m.pack_id);

  // Get check-ins
  let query = supabase
    .from('check_ins')
    .select(
      `
      *,
      goal:goals(title, base_xp),
      user:users(username, display_name, avatar_url)
    `
    )
    .in('pack_id', packIds)
    .order('checked_in_at', { ascending: false })
    .limit(filters?.limit || 20)
    .range(filters?.offset || 0, (filters?.offset || 0) + (filters?.limit || 20) - 1);

  const { data: checkIns, error } = await query;

  if (error) {
    console.error('Feed fetch error:', error);
    throw new InternalError('Failed to fetch feed');
  }

  // Get reactions and comments count for each check-in
  const checkInsWithCounts = await Promise.all(
    (checkIns || []).map(async (checkIn) => {
      const { count: reactionsCount } = await supabase
        .from('reactions')
        .select('*', { count: 'exact', head: true })
        .eq('check_in_id', checkIn.id);

      const { count: commentsCount } = await supabase
        .from('comments')
        .select('*', { count: 'exact', head: true })
        .eq('check_in_id', checkIn.id);

      return {
        ...checkIn,
        goal: checkIn.goal,
        user: checkIn.user,
        reactions_count: reactionsCount || 0,
        comments_count: commentsCount || 0,
      } as FeedItem;
    })
  );

  return checkInsWithCounts;
}

/**
 * Get check-ins for a specific pack
 */
export async function getPackCheckIns(
  supabase: SupabaseClient,
  packId: string,
  filters?: {
    user_id?: string;
    goal_id?: string;
    status?: string;
    limit?: number;
    offset?: number;
  }
): Promise<CheckIn[]> {
  let query = supabase
    .from('check_ins')
    .select(
      '*, goal:goals(title, base_xp), user:users(username, display_name, avatar_url)'
    )
    .eq('pack_id', packId)
    .order('checked_in_at', { ascending: false });

  if (filters?.user_id) {
    query = query.eq('user_id', filters.user_id);
  }

  if (filters?.goal_id) {
    query = query.eq('goal_id', filters.goal_id);
  }

  if (filters?.status) {
    query = query.eq('status', filters.status);
  }

  query = query
    .limit(filters?.limit || 20)
    .range(
      filters?.offset || 0,
      (filters?.offset || 0) + (filters?.limit || 20) - 1
    );

  const { data: checkIns, error } = await query;

  if (error) {
    console.error('Pack check-ins fetch error:', error);
    throw new InternalError('Failed to fetch check-ins');
  }

  return (checkIns || []).map((checkIn) => ({
    ...checkIn,
    goal: checkIn.goal,
    user: checkIn.user,
  })) as CheckIn[];
}

/**
 * Get a specific check-in
 */
export async function getCheckIn(
  supabase: SupabaseClient,
  checkInId: string
): Promise<CheckIn> {
  const { data: checkIn, error } = await supabase
    .from('check_ins')
    .select(
      '*, goal:goals(title, base_xp), user:users(username, display_name, avatar_url)'
    )
    .eq('id', checkInId)
    .single();

  if (error || !checkIn) {
    throw new NotFoundError('Check-in');
  }

  return {
    ...checkIn,
    goal: checkIn.goal,
    user: checkIn.user,
  } as CheckIn;
}

/**
 * Get user's check-in statistics
 */
export async function getUserCheckInStats(
  supabase: SupabaseClient,
  userId: string
): Promise<CheckInStats> {
  // Get all user check-ins
  const { data: checkIns, count: totalCount } = await supabase
    .from('check_ins')
    .select('*, goal:goals(recurrence_rule, created_at)', { count: 'exact' })
    .eq('user_id', userId);

  // Get user data
  const { data: user } = await supabase
    .from('users')
    .select('current_streak, longest_streak, total_xp')
    .eq('id', userId)
    .single();

  // Calculate period-specific counts
  const weekRange = getDateRange('week');
  const monthRange = getDateRange('month');

  const thisWeek = (checkIns || []).filter(
    (c) => new Date(c.checked_in_at) >= weekRange.start
  ).length;

  const thisMonth = (checkIns || []).filter(
    (c) => new Date(c.checked_in_at) >= monthRange.start
  ).length;

  // Calculate success rate (simplified)
  const daysSinceFirstGoal = checkIns?.length
    ? Math.max(
        1,
        Math.floor(
          (Date.now() - new Date(checkIns[0].created_at).getTime()) /
            (1000 * 60 * 60 * 24)
        )
      )
    : 1;

  const successRate = calculateSuccessRate(totalCount || 0, daysSinceFirstGoal);

  return {
    total_checkins: totalCount || 0,
    current_streak: user?.current_streak || 0,
    longest_streak: user?.longest_streak || 0,
    total_xp_earned: user?.total_xp || 0,
    success_rate: successRate,
    this_week: thisWeek,
    this_month: thisMonth,
  };
}

/**
 * Delete a check-in (admin or owner only)
 */
export async function deleteCheckIn(
  supabase: SupabaseClient,
  checkInId: string,
  userId: string
): Promise<void> {
  const checkIn = await getCheckIn(supabase, checkInId);

  // Only owner can delete their check-in
  if (checkIn.user_id !== userId) {
    throw new ForbiddenError('You can only delete your own check-ins');
  }

  const { error } = await supabase
    .from('check_ins')
    .delete()
    .eq('id', checkInId);

  if (error) {
    console.error('Check-in deletion error:', error);
    throw new InternalError('Failed to delete check-in');
  }

  // TODO: Reverse XP and streak updates (complex - would need transaction)
}
