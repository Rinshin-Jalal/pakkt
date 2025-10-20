-- Migration 011: Comprehensive Indexes for Performance
-- 40+ indexes for foreign keys, timestamps, status filters, and search patterns

-- Foreign Key Indexes
CREATE INDEX IF NOT EXISTS idx_packs_creator_id ON packs(creator_id);
CREATE INDEX IF NOT EXISTS idx_pack_members_pack_id ON pack_members(pack_id);
CREATE INDEX IF NOT EXISTS idx_pack_members_user_id ON pack_members(user_id);
CREATE INDEX IF NOT EXISTS idx_goals_pack_id ON goals(pack_id);
CREATE INDEX IF NOT EXISTS idx_goals_creator_id ON goals(creator_id);
CREATE INDEX IF NOT EXISTS idx_check_ins_goal_id ON check_ins(goal_id);
CREATE INDEX IF NOT EXISTS idx_check_ins_user_id ON check_ins(user_id);
CREATE INDEX IF NOT EXISTS idx_check_ins_pack_id ON check_ins(pack_id);
CREATE INDEX IF NOT EXISTS idx_fines_check_in_id ON fines(check_in_id);
CREATE INDEX IF NOT EXISTS idx_fines_pack_id ON fines(pack_id);
CREATE INDEX IF NOT EXISTS idx_fines_user_id ON fines(user_id);
CREATE INDEX IF NOT EXISTS idx_fine_votes_fine_id ON fine_votes(fine_id);
CREATE INDEX IF NOT EXISTS idx_fine_votes_voter_id ON fine_votes(voter_id);
CREATE INDEX IF NOT EXISTS idx_punishments_user_id ON punishments(user_id);
CREATE INDEX IF NOT EXISTS idx_punishments_pack_id ON punishments(pack_id);
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_pack_id ON transactions(pack_id);
CREATE INDEX IF NOT EXISTS idx_feed_events_pack_id ON feed_events(pack_id);
CREATE INDEX IF NOT EXISTS idx_feed_events_user_id ON feed_events(user_id);

-- Status & Status Filter Indexes
CREATE INDEX IF NOT EXISTS idx_packs_status ON packs(status);
CREATE INDEX IF NOT EXISTS idx_goals_active ON goals(active);
CREATE INDEX IF NOT EXISTS idx_check_ins_status ON check_ins(status);
CREATE INDEX IF NOT EXISTS idx_fines_status ON fines(status);
CREATE INDEX IF NOT EXISTS idx_punishments_status ON punishments(status);
CREATE INDEX IF NOT EXISTS idx_punishments_type ON punishments(type);
CREATE INDEX IF NOT EXISTS idx_transactions_status ON transactions(status);
CREATE INDEX IF NOT EXISTS idx_transactions_type ON transactions(type);
CREATE INDEX IF NOT EXISTS idx_user_powerups_status ON user_powerups(status);
CREATE INDEX IF NOT EXISTS idx_challenge_rooms_status ON challenge_rooms(status);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);

-- Timestamp Indexes
CREATE INDEX IF NOT EXISTS idx_packs_created_at ON packs(created_at);
CREATE INDEX IF NOT EXISTS idx_goals_created_at ON goals(created_at);
CREATE INDEX IF NOT EXISTS idx_check_ins_created_at ON check_ins(created_at);
CREATE INDEX IF NOT EXISTS idx_fines_created_at ON fines(created_at);
CREATE INDEX IF NOT EXISTS idx_fine_votes_created_at ON fine_votes(created_at);
CREATE INDEX IF NOT EXISTS idx_phone_jails_started_at ON phone_jails(started_at);
CREATE INDEX IF NOT EXISTS idx_transactions_created_at ON transactions(created_at);
CREATE INDEX IF NOT EXISTS idx_feed_events_created_at ON feed_events(created_at);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at);
CREATE INDEX IF NOT EXISTS idx_reactions_created_at ON reactions(created_at);

-- Composite Indexes for Common Queries
CREATE INDEX IF NOT EXISTS idx_check_ins_pack_user_date ON check_ins(pack_id, user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_check_ins_user_goal_date ON check_ins(user_id, goal_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_feed_events_pack_visibility_date ON feed_events(pack_id, visibility, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_pack_members_pack_active ON pack_members(pack_id, is_active);
CREATE INDEX IF NOT EXISTS idx_pack_members_user_active ON pack_members(user_id, is_active);
CREATE INDEX IF NOT EXISTS idx_fines_pack_status_date ON fines(pack_id, status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_transactions_user_status_date ON transactions(user_id, status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_challenge_participants_challenge_user ON challenge_participants(challenge_id, user_id);
CREATE INDEX IF NOT EXISTS idx_reactions_check_in_user ON reactions(check_in_id, user_id);
CREATE INDEX IF NOT EXISTS idx_comments_check_in_user ON comments(check_in_id, user_id);

-- Event Type Indexes
CREATE INDEX IF NOT EXISTS idx_feed_events_event_type ON feed_events(event_type);
CREATE INDEX IF NOT EXISTS idx_feed_events_visibility ON feed_events(visibility);
CREATE INDEX IF NOT EXISTS idx_reputation_log_action ON reputation_log(action);
CREATE INDEX IF NOT EXISTS idx_reputation_log_voter_id ON reputation_log(voter_id);
CREATE INDEX IF NOT EXISTS idx_pack_members_role ON pack_members(role);

-- Phone Jails and Notifications Indexes
CREATE INDEX IF NOT EXISTS idx_phone_jails_user_id ON phone_jails(user_id);
CREATE INDEX IF NOT EXISTS idx_phone_jails_pack_id ON phone_jails(pack_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_challenge_rooms_creator_id ON challenge_rooms(creator_id);
CREATE INDEX IF NOT EXISTS idx_challenge_participants_challenge_id ON challenge_participants(challenge_id);
CREATE INDEX IF NOT EXISTS idx_challenge_participants_user_id ON challenge_participants(user_id);

-- Social Features Indexes
CREATE INDEX IF NOT EXISTS idx_reactions_user_id ON reactions(user_id);
CREATE INDEX IF NOT EXISTS idx_reactions_check_in_id ON reactions(check_in_id);
CREATE INDEX IF NOT EXISTS idx_reactions_feed_event_id ON reactions(feed_event_id);
CREATE INDEX IF NOT EXISTS idx_comments_user_id ON comments(user_id);
CREATE INDEX IF NOT EXISTS idx_comments_check_in_id ON comments(check_in_id);
CREATE INDEX IF NOT EXISTS idx_comments_feed_event_id ON comments(feed_event_id);
CREATE INDEX IF NOT EXISTS idx_user_powerups_user_id ON user_powerups(user_id);

-- Partial Indexes for Performance
CREATE INDEX IF NOT EXISTS idx_check_ins_pending_vote ON check_ins(pack_id) WHERE status = 'pending_vote';
CREATE INDEX IF NOT EXISTS idx_fines_pending ON fines(pack_id) WHERE status = 'pending';
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON notifications(user_id) WHERE is_read = false;
CREATE INDEX IF NOT EXISTS idx_phone_jails_active ON phone_jails(user_id) WHERE ended_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_goals_active_pack ON goals(pack_id) WHERE active = true;
CREATE INDEX IF NOT EXISTS idx_pack_members_active_pack ON pack_members(pack_id) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_challenge_rooms_active ON challenge_rooms(status) WHERE status IN ('upcoming', 'active');

-- Covering Indexes for Common Queries
CREATE INDEX IF NOT EXISTS idx_feed_events_pack_user_type ON feed_events(pack_id, user_id, event_type, visibility, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_check_ins_status_verified ON check_ins(status, verified_at, xp_awarded) WHERE status = 'success';
