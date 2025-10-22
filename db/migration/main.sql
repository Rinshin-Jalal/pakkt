-- Migration 001: Initial users table
-- This table stores every account and personal progression

CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  username text UNIQUE NOT NULL,
  profile_pic text,
  bio text,
  xp integer DEFAULT 0 NOT NULL,
  level integer DEFAULT 1 NOT NULL,
  coins integer DEFAULT 0 NOT NULL,
  streak_count integer DEFAULT 0 NOT NULL,
  phone_jail_opt_in boolean DEFAULT false NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  last_active timestamp with time zone DEFAULT now()
);

-- Indexes for users table
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Comment for clarity
COMMENT ON TABLE users IS 'Stores every account and personal progression. Tracks XP, coins, streaks, and phone jail preferences.';
COMMENT ON COLUMN users.xp IS 'Total earned XP representing accountability score';
COMMENT ON COLUMN users.level IS 'Derived from XP tiers (dynamically calculated)';
COMMENT ON COLUMN users.coins IS 'In-app currency for power-ups';
COMMENT ON COLUMN users.streak_count IS 'Consecutive successful check-ins';
COMMENT ON COLUMN users.phone_jail_opt_in IS 'Whether user allows Screen Time blocking';

-- Migration 002: Packs table
-- Groups of users enforcing shared accountability

CREATE TABLE IF NOT EXISTS packs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  creator_id uuid NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  xp integer DEFAULT 0 NOT NULL,
  level integer DEFAULT 1 NOT NULL,
  goal_type text,
  status text DEFAULT 'active' NOT NULL CHECK (status IN ('active', 'dissolved')),
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now(),
  last_activity timestamp with time zone DEFAULT now()
);

-- Indexes for packs
CREATE INDEX idx_packs_creator_id ON packs(creator_id);
CREATE INDEX idx_packs_status ON packs(status);
CREATE INDEX idx_packs_created_at ON packs(created_at);

COMMENT ON TABLE packs IS 'Groups of users enforcing shared accountability. Tracks collective XP and pack progression.';
COMMENT ON COLUMN packs.xp IS 'Collective XP earned by pack members';
COMMENT ON COLUMN packs.level IS 'Derived from collective XP tiers';
COMMENT ON COLUMN packs.goal_type IS 'Category of goals (e.g., gym, study, sobriety)';
COMMENT ON COLUMN packs.status IS 'Lifecycle state: active or dissolved';

-- Migration 003: Pack members join table
-- Links users to packs with roles and reputation tracking

CREATE TABLE IF NOT EXISTS pack_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  pack_id uuid NOT NULL REFERENCES packs(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role text DEFAULT 'member' NOT NULL CHECK (role IN ('member', 'admin')),
  join_date timestamp with time zone DEFAULT now() NOT NULL,
  reputation_xp integer DEFAULT 0 NOT NULL,
  is_active boolean DEFAULT true NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  UNIQUE(pack_id, user_id)
);

-- Indexes for pack_members
CREATE INDEX idx_pack_members_pack_id ON pack_members(pack_id);
CREATE INDEX idx_pack_members_user_id ON pack_members(user_id);
CREATE INDEX idx_pack_members_role ON pack_members(role);
CREATE INDEX idx_pack_members_is_active ON pack_members(is_active);

COMMENT ON TABLE pack_members IS 'Join table linking users to packs. Tracks membership role, reputation, and activity status.';
COMMENT ON COLUMN pack_members.role IS 'member or admin - determines permissions';
COMMENT ON COLUMN pack_members.reputation_xp IS 'XP earned through fair voting behavior - affects vote weight';
COMMENT ON COLUMN pack_members.is_active IS 'Quick filter for active vs inactive members';

-- Migration 004: Goals table
-- Each commitment inside a pack with timing and consequence config

CREATE TABLE IF NOT EXISTS goals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  pack_id uuid NOT NULL REFERENCES packs(id) ON DELETE CASCADE,
  creator_id uuid NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  title text NOT NULL,
  schedule jsonb, -- e.g., {days: ["Mon","Wed"], time:"07:00"}
  fine_amount integer DEFAULT 5 NOT NULL,
  jail_duration integer DEFAULT 30 NOT NULL, -- in minutes
  proof_required boolean DEFAULT false NOT NULL,
  active boolean DEFAULT true NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now()
);

-- Indexes for goals
CREATE INDEX idx_goals_pack_id ON goals(pack_id);
CREATE INDEX idx_goals_creator_id ON goals(creator_id);
CREATE INDEX idx_goals_active ON goals(active);
CREATE INDEX idx_goals_created_at ON goals(created_at);

COMMENT ON TABLE goals IS 'Pack commitments with timing and consequence configuration. Defines what members must do and when.';
COMMENT ON COLUMN goals.schedule IS 'JSON object with days array and time string (ISO 8601)';
COMMENT ON COLUMN goals.fine_amount IS 'Default financial consequence in cents';
COMMENT ON COLUMN goals.jail_duration IS 'Screen time lock duration in minutes';
COMMENT ON COLUMN goals.proof_required IS 'Whether photo/video proof is mandatory';

-- Migration 005: Check-ins table
-- Daily evidence of goal completion with streak tracking

CREATE TABLE IF NOT EXISTS check_ins (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  goal_id uuid NOT NULL REFERENCES goals(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  pack_id uuid NOT NULL REFERENCES packs(id) ON DELETE CASCADE,
  status text DEFAULT 'pending_vote' NOT NULL CHECK (status IN ('success', 'missed', 'pending_vote')),
  proof_url text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  verified_at timestamp with time zone,
  xp_awarded integer DEFAULT 0,
  updated_at timestamp with time zone DEFAULT now()
);

-- Indexes for check_ins
CREATE INDEX idx_check_ins_goal_id ON check_ins(goal_id);
CREATE INDEX idx_check_ins_user_id ON check_ins(user_id);
CREATE INDEX idx_check_ins_pack_id ON check_ins(pack_id);
CREATE INDEX idx_check_ins_status ON check_ins(status);
CREATE INDEX idx_check_ins_created_at ON check_ins(created_at);
CREATE INDEX idx_check_ins_pack_user_date ON check_ins(pack_id, user_id, created_at DESC);

COMMENT ON TABLE check_ins IS 'Daily submissions of goal completion with media proof and streak data.';
COMMENT ON COLUMN check_ins.status IS 'success (verified), missed (flagged), or pending_vote (awaiting pack decision)';
COMMENT ON COLUMN check_ins.proof_url IS 'Media URL (photo/video) if proof_required=true on goal';
COMMENT ON COLUMN check_ins.xp_awarded IS 'XP gained on verification (0 until resolved)';

-- Migration 006: Fines and voting tables
-- Democratic punishment system via peer voting

CREATE TABLE IF NOT EXISTS fines (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  check_in_id uuid NOT NULL REFERENCES check_ins(id) ON DELETE CASCADE,
  pack_id uuid NOT NULL REFERENCES packs(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  amount integer NOT NULL, -- in cents
  status text DEFAULT 'pending' NOT NULL CHECK (status IN ('pending', 'enforced', 'appealed', 'cancelled')),
  voting_ends_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS fine_votes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  fine_id uuid NOT NULL REFERENCES fines(id) ON DELETE CASCADE,
  voter_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  vote boolean NOT NULL, -- true = enforce, false = dismiss
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

-- Indexes for fines
CREATE INDEX idx_fines_check_in_id ON fines(check_in_id);
CREATE INDEX idx_fines_pack_id ON fines(pack_id);
CREATE INDEX idx_fines_user_id ON fines(user_id);
CREATE INDEX idx_fines_status ON fines(status);
CREATE INDEX idx_fines_created_at ON fines(created_at);

-- Indexes for fine_votes
CREATE INDEX idx_fine_votes_fine_id ON fine_votes(fine_id);
CREATE INDEX idx_fine_votes_voter_id ON fine_votes(voter_id);
CREATE INDEX idx_fine_votes_created_at ON fine_votes(created_at);

COMMENT ON TABLE fines IS 'Executed consequences from missed check-ins. Stored on-chain for voting and appeals.';
COMMENT ON COLUMN fines.status IS 'pending (voting), enforced (executed), appealed (disputed), or cancelled';
COMMENT ON COLUMN fines.voting_ends_at IS 'Timestamp when voting window closes';

COMMENT ON TABLE fine_votes IS 'Individual votes from pack members on whether to enforce a fine.';
COMMENT ON COLUMN fine_votes.vote IS 'true = yes enforce, false = no dismiss';

-- Migration 006: Fines and voting tables
-- Democratic punishment system via peer voting

CREATE TABLE IF NOT EXISTS fines (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  check_in_id uuid NOT NULL REFERENCES check_ins(id) ON DELETE CASCADE,
  pack_id uuid NOT NULL REFERENCES packs(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  amount integer NOT NULL, -- in cents
  status text DEFAULT 'pending' NOT NULL CHECK (status IN ('pending', 'enforced', 'appealed', 'cancelled')),
  voting_ends_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS fine_votes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  fine_id uuid NOT NULL REFERENCES fines(id) ON DELETE CASCADE,
  voter_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  vote boolean NOT NULL, -- true = enforce, false = dismiss
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

-- Indexes for fines
CREATE INDEX idx_fines_check_in_id ON fines(check_in_id);
CREATE INDEX idx_fines_pack_id ON fines(pack_id);
CREATE INDEX idx_fines_user_id ON fines(user_id);
CREATE INDEX idx_fines_status ON fines(status);
CREATE INDEX idx_fines_created_at ON fines(created_at);

-- Indexes for fine_votes
CREATE INDEX idx_fine_votes_fine_id ON fine_votes(fine_id);
CREATE INDEX idx_fine_votes_voter_id ON fine_votes(voter_id);
CREATE INDEX idx_fine_votes_created_at ON fine_votes(created_at);

COMMENT ON TABLE fines IS 'Executed consequences from missed check-ins. Stored on-chain for voting and appeals.';
COMMENT ON COLUMN fines.status IS 'pending (voting), enforced (executed), appealed (disputed), or cancelled';
COMMENT ON COLUMN fines.voting_ends_at IS 'Timestamp when voting window closes';

COMMENT ON TABLE fine_votes IS 'Individual votes from pack members on whether to enforce a fine.';
COMMENT ON COLUMN fine_votes.vote IS 'true = yes enforce, false = no dismiss';

-- Migration 008: Advanced social features
-- Reactions, comments, feed events, challenges, notifications, reputation tracking

CREATE TABLE IF NOT EXISTS reactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  check_in_id uuid REFERENCES check_ins(id) ON DELETE CASCADE,
  feed_event_id uuid,
  emoji text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  check_in_id uuid REFERENCES check_ins(id) ON DELETE CASCADE,
  feed_event_id uuid,
  content text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS feed_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  pack_id uuid NOT NULL REFERENCES packs(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  event_type text NOT NULL CHECK (event_type IN ('checkin_success', 'fine_voted', 'jail_served', 'level_up', 'powerup_used', 'pack_milestone')),
  metadata jsonb,
  visibility text DEFAULT 'pack' NOT NULL CHECK (visibility IN ('private', 'pack', 'public')),
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS challenge_rooms (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  creator_id uuid NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  entry_fee integer DEFAULT 0,
  prize_pool integer DEFAULT 0,
  status text DEFAULT 'upcoming' NOT NULL CHECK (status IN ('upcoming', 'active', 'ended')),
  start_date timestamp with time zone NOT NULL,
  end_date timestamp with time zone NOT NULL,
  created_at timestamp with time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS challenge_participants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  challenge_id uuid NOT NULL REFERENCES challenge_rooms(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  progress integer DEFAULT 0,
  eliminated boolean DEFAULT false,
  earned integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  UNIQUE(challenge_id, user_id)
);

CREATE TABLE IF NOT EXISTS notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type text NOT NULL,
  message text NOT NULL,
  is_read boolean DEFAULT false NOT NULL,
  related_entity_id uuid,
  created_at timestamp with time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS reputation_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  voter_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  action text NOT NULL CHECK (action IN ('fair_vote', 'false_vote', 'appeal_upheld')),
  delta integer NOT NULL,
  reason text,
  created_at timestamp with time zone DEFAULT now()
);

CREATE INDEX idx_reactions_user_id ON reactions(user_id);
CREATE INDEX idx_reactions_check_in_id ON reactions(check_in_id);
CREATE INDEX idx_reactions_created_at ON reactions(created_at);

CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_comments_check_in_id ON comments(check_in_id);

CREATE INDEX idx_feed_events_pack_id ON feed_events(pack_id);
CREATE INDEX idx_feed_events_user_id ON feed_events(user_id);
CREATE INDEX idx_feed_events_event_type ON feed_events(event_type);
CREATE INDEX idx_feed_events_visibility ON feed_events(visibility);
CREATE INDEX idx_feed_events_created_at ON feed_events(created_at);

CREATE INDEX idx_challenge_rooms_status ON challenge_rooms(status);
CREATE INDEX idx_challenge_rooms_creator_id ON challenge_rooms(creator_id);

CREATE INDEX idx_challenge_participants_challenge_id ON challenge_participants(challenge_id);
CREATE INDEX idx_challenge_participants_user_id ON challenge_participants(user_id);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);

CREATE INDEX idx_reputation_log_voter_id ON reputation_log(voter_id);
CREATE INDEX idx_reputation_log_action ON reputation_log(action);

COMMENT ON TABLE reactions IS 'Emoji reactions to check-ins and feed events for social engagement.';
COMMENT ON TABLE comments IS 'Text comments on check-ins and feed events.';
COMMENT ON TABLE feed_events IS 'Master social activity log with visibility controls (private/pack/public).';
COMMENT ON TABLE challenge_rooms IS 'Public, time-limited competitions across packs.';
COMMENT ON TABLE notifications IS 'Push notification records for user alerts.';
COMMENT ON TABLE reputation_log IS 'Audit trail of reputation changes to track voting integrity.';

-- Migration 009: Database functions
-- Reusable, atomic operations for core business logic

CREATE OR REPLACE FUNCTION calculate_streak(p_user_id uuid, p_pack_id uuid)
RETURNS integer AS $$
DECLARE
  v_streak integer := 0;
  v_last_date date;
BEGIN
  FOR v_last_date IN
    SELECT DISTINCT DATE(created_at)
    FROM check_ins
    WHERE user_id = p_user_id
      AND pack_id = p_pack_id
      AND status = 'success'
    ORDER BY DATE(created_at) DESC
  LOOP
    IF v_last_date = CURRENT_DATE - (v_streak || ' days')::interval THEN
      v_streak := v_streak + 1;
    ELSE
      EXIT;
    END IF;
  END LOOP;

  RETURN v_streak;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calculate_user_level(p_xp integer)
RETURNS integer AS $$
BEGIN
  RETURN GREATEST(1, (p_xp / 100) + 1);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calculate_pack_level(p_xp integer)
RETURNS integer AS $$
BEGIN
  RETURN GREATEST(1, (p_xp / 500) + 1);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calculate_vote_weight(p_reputation_xp integer)
RETURNS numeric AS $$
BEGIN
  RETURN LEAST(2.0, GREATEST(0.5, 1.0 + (p_reputation_xp::numeric / 500.0)));
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION detect_cheating(p_user_id uuid, p_goal_id uuid)
RETURNS boolean AS $$
DECLARE
  v_recent_count integer;
BEGIN
  SELECT COUNT(*)
  INTO v_recent_count
  FROM check_ins
  WHERE user_id = p_user_id
    AND goal_id = p_goal_id
    AND created_at > NOW() - INTERVAL '5 minutes';

  RETURN v_recent_count > 1;
END;
$$ LANGUAGE plpgsql STABLE;

CREATE OR REPLACE FUNCTION award_xp(
  p_user_id uuid,
  p_pack_id uuid,
  p_amount integer,
  p_reason text DEFAULT 'check_in'
)
RETURNS TABLE(new_user_xp integer, new_pack_xp integer) AS $$
BEGIN
  UPDATE users
  SET xp = xp + p_amount, updated_at = NOW()
  WHERE id = p_user_id;

  UPDATE packs
  SET xp = xp + p_amount, updated_at = NOW()
  WHERE id = p_pack_id;

  RETURN QUERY
  SELECT u.xp, p.xp
  FROM users u, packs p
  WHERE u.id = p_user_id AND p.id = p_pack_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_feed_for_user(
  p_user_id uuid,
  p_limit integer DEFAULT 50,
  p_offset integer DEFAULT 0
)
RETURNS TABLE(
  id uuid,
  pack_id uuid,
  user_id uuid,
  event_type text,
  metadata jsonb,
  visibility text,
  created_at timestamp with time zone
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    fe.id,
    fe.pack_id,
    fe.user_id,
    fe.event_type,
    fe.metadata,
    fe.visibility,
    fe.created_at
  FROM feed_events fe
  LEFT JOIN pack_members pm ON fe.pack_id = pm.pack_id AND pm.user_id = p_user_id
  WHERE
    fe.visibility = 'public'
    OR (fe.visibility = 'private' AND (fe.user_id = p_user_id OR pm.role = 'admin'))
    OR (fe.visibility = 'pack' AND pm.pack_id IS NOT NULL)
  ORDER BY fe.created_at DESC
  LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql STABLE;

CREATE OR REPLACE FUNCTION enforce_punishment(
  p_punishment_id uuid,
  p_enforcer_id uuid
)
RETURNS TABLE(success boolean, error_message text) AS $$
DECLARE
  v_punishment punishments%ROWTYPE;
BEGIN
  SELECT * INTO v_punishment
  FROM punishments
  WHERE id = p_punishment_id AND status = 'pending';

  IF v_punishment IS NULL THEN
    RETURN QUERY SELECT false, 'Punishment not found or already executed';
    RETURN;
  END IF;

  IF v_punishment.type = 'jail' THEN
    INSERT INTO phone_jails (user_id, pack_id, duration_minutes, reason)
    VALUES (v_punishment.user_id, v_punishment.pack_id, v_punishment.amount, 'From fine');
  END IF;

  UPDATE punishments
  SET status = 'served', enforced_by = p_enforcer_id, completed_at = NOW()
  WHERE id = p_punishment_id;

  RETURN QUERY SELECT true, NULL;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION calculate_streak(uuid, uuid) IS 'Calculate consecutive successful check-ins for a user in a pack';
COMMENT ON FUNCTION calculate_user_level(integer) IS 'Derive user level from XP (linear: 100 XP per level)';
COMMENT ON FUNCTION calculate_pack_level(integer) IS 'Derive pack level from XP (linear: 500 XP per level)';
COMMENT ON FUNCTION calculate_vote_weight(integer) IS 'Calculate vote weight multiplier (0.5x-2.0x) based on reputation XP';
COMMENT ON FUNCTION detect_cheating(uuid, uuid) IS 'Detect duplicate submissions within 5 minutes';
COMMENT ON FUNCTION award_xp(uuid, uuid, integer, text) IS 'Atomically award XP to user and pack with logging';
COMMENT ON FUNCTION get_feed_for_user(uuid, integer, integer) IS 'Get user feed with visibility-based filtering';
COMMENT ON FUNCTION enforce_punishment(uuid, uuid) IS 'Execute punishment (fine or jail) and mark as served';
-- Migration 010: Triggers
-- Automated workflows for timestamps, calculations, and event logging

CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_timestamp BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_packs_timestamp BEFORE UPDATE ON packs FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_pack_members_timestamp BEFORE UPDATE ON pack_members FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_goals_timestamp BEFORE UPDATE ON goals FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_check_ins_timestamp BEFORE UPDATE ON check_ins FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_fines_timestamp BEFORE UPDATE ON fines FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_punishments_timestamp BEFORE UPDATE ON punishments FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER update_comments_timestamp BEFORE UPDATE ON comments FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE OR REPLACE FUNCTION on_check_in_success()
RETURNS TRIGGER AS $$
DECLARE
  v_xp_award integer := 10;
  v_streak integer;
  v_is_cheating boolean;
BEGIN
  IF NEW.status = 'success' AND OLD.status IS DISTINCT FROM 'success' THEN
    v_is_cheating := detect_cheating(NEW.user_id, NEW.goal_id);

    IF v_is_cheating THEN
      UPDATE check_ins SET status = 'missed' WHERE id = NEW.id;
      RETURN NEW;
    END IF;

    v_streak := calculate_streak(NEW.user_id, NEW.pack_id);

    IF v_streak > 1 THEN
      v_xp_award := v_xp_award + 5;
    END IF;

    UPDATE users SET xp = xp + v_xp_award, updated_at = NOW() WHERE id = NEW.user_id;
    UPDATE packs SET xp = xp + v_xp_award, updated_at = NOW() WHERE id = NEW.pack_id;

    NEW.xp_awarded := v_xp_award;
    NEW.verified_at := NOW();

    INSERT INTO feed_events (pack_id, user_id, event_type, metadata, visibility, created_at)
    VALUES (
      NEW.pack_id,
      NEW.user_id,
      'checkin_success',
      jsonb_build_object('check_in_id', NEW.id, 'xp_awarded', v_xp_award, 'streak', v_streak),
      'pack',
      NOW()
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_check_in_success_trigger BEFORE UPDATE ON check_ins FOR EACH ROW EXECUTE FUNCTION on_check_in_success();

CREATE OR REPLACE FUNCTION on_user_xp_change()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.xp IS DISTINCT FROM OLD.xp THEN
    NEW.level := calculate_user_level(NEW.xp);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_user_xp_change_trigger BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION on_user_xp_change();

CREATE OR REPLACE FUNCTION on_pack_xp_change()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.xp IS DISTINCT FROM OLD.xp THEN
    NEW.level := calculate_pack_level(NEW.xp);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_pack_xp_change_trigger BEFORE UPDATE ON packs FOR EACH ROW EXECUTE FUNCTION on_pack_xp_change();

CREATE OR REPLACE FUNCTION on_fine_enforced()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'enforced' AND OLD.status IS DISTINCT FROM 'enforced' THEN
    INSERT INTO feed_events (pack_id, user_id, event_type, metadata, visibility, created_at)
    VALUES (
      NEW.pack_id,
      NEW.user_id,
      'fine_voted',
      jsonb_build_object('fine_id', NEW.id, 'amount', NEW.amount),
      'pack',
      NOW()
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_fine_enforced_trigger AFTER UPDATE ON fines FOR EACH ROW EXECUTE FUNCTION on_fine_enforced();

CREATE OR REPLACE FUNCTION on_user_level_up()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.level > OLD.level THEN
    INSERT INTO feed_events (pack_id, user_id, event_type, metadata, visibility, created_at)
    SELECT
      pm.pack_id,
      NEW.id,
      'level_up',
      jsonb_build_object('old_level', OLD.level, 'new_level', NEW.level, 'xp', NEW.xp),
      'pack',
      NOW()
    FROM pack_members pm
    WHERE pm.user_id = NEW.id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_user_level_up_trigger AFTER UPDATE ON users FOR EACH ROW EXECUTE FUNCTION on_user_level_up();

CREATE OR REPLACE FUNCTION on_fine_created()
RETURNS TRIGGER AS $$
DECLARE
  v_member pack_members%ROWTYPE;
BEGIN
  FOR v_member IN
    SELECT * FROM pack_members WHERE pack_id = NEW.pack_id AND user_id != NEW.user_id
  LOOP
    INSERT INTO notifications (user_id, type, message, related_entity_id, created_at)
    VALUES (
      v_member.user_id,
      'vote_request',
      'New fine to vote on',
      NEW.id,
      NOW()
    );
  END LOOP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_fine_created_trigger AFTER INSERT ON fines FOR EACH ROW EXECUTE FUNCTION on_fine_created();

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

-- Migration 012: Row-Level Security (RLS) Policies
-- Comprehensive access control based on user roles and pack membership

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE packs ENABLE ROW LEVEL SECURITY;
ALTER TABLE pack_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE check_ins ENABLE ROW LEVEL SECURITY;
ALTER TABLE fines ENABLE ROW LEVEL SECURITY;
ALTER TABLE fine_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE phone_jails ENABLE ROW LEVEL SECURITY;
ALTER TABLE punishments ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE powerups ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_powerups ENABLE ROW LEVEL SECURITY;
ALTER TABLE reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE feed_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenge_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenge_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE reputation_log ENABLE ROW LEVEL SECURITY;

-- USERS
CREATE POLICY "Users can read own profile" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid() = id);

-- PACKS
CREATE POLICY "Users can read packs they're in" ON packs FOR SELECT
  USING (auth.uid() = creator_id OR EXISTS (SELECT 1 FROM pack_members WHERE pack_id = packs.id AND user_id = auth.uid() AND is_active = true));

CREATE POLICY "Pack admins can update pack" ON packs FOR UPDATE
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = packs.id AND user_id = auth.uid() AND role = 'admin'));

CREATE POLICY "Only creator can delete pack" ON packs FOR DELETE USING (auth.uid() = creator_id);

-- PACK_MEMBERS
CREATE POLICY "Users can read their pack memberships" ON pack_members FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM pack_members pm WHERE pm.pack_id = pack_members.pack_id AND pm.user_id = auth.uid() AND pm.role = 'admin'));

CREATE POLICY "Admins can update pack members" ON pack_members FOR UPDATE
  USING (EXISTS (SELECT 1 FROM pack_members pm WHERE pm.pack_id = pack_members.pack_id AND pm.user_id = auth.uid() AND pm.role = 'admin'));

-- GOALS
CREATE POLICY "Pack members can read goals" ON goals FOR SELECT
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = goals.pack_id AND user_id = auth.uid() AND is_active = true));

CREATE POLICY "Pack admins can manage goals" ON goals FOR UPDATE
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = goals.pack_id AND user_id = auth.uid() AND role = 'admin'));

CREATE POLICY "Goal creator can delete" ON goals FOR DELETE USING (auth.uid() = creator_id);

-- CHECK_INS
CREATE POLICY "Pack members can read check-ins" ON check_ins FOR SELECT
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = check_ins.pack_id AND user_id = auth.uid() AND is_active = true));

CREATE POLICY "Users can create own check-ins" ON check_ins FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own check-ins" ON check_ins FOR UPDATE USING (auth.uid() = user_id);

-- FINES
CREATE POLICY "Pack members can read fines" ON fines FOR SELECT
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = fines.pack_id AND user_id = auth.uid() AND is_active = true));

CREATE POLICY "Admins can manage fines" ON fines FOR UPDATE
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = fines.pack_id AND user_id = auth.uid() AND role = 'admin'));

-- FINE_VOTES
CREATE POLICY "Pack members can read fine votes" ON fine_votes FOR SELECT
  USING (EXISTS (SELECT 1 FROM fine_votes fv JOIN fines f ON fv.fine_id = f.id JOIN pack_members pm ON f.pack_id = pm.pack_id WHERE pm.user_id = auth.uid() AND pm.is_active = true AND fv.fine_id = fine_votes.fine_id));

CREATE POLICY "Pack members can vote on fines" ON fine_votes FOR INSERT
  WITH CHECK (auth.uid() = voter_id AND EXISTS (SELECT 1 FROM fines f JOIN pack_members pm ON f.pack_id = pm.pack_id WHERE pm.user_id = auth.uid() AND f.id = fine_votes.fine_id));

-- TRANSACTIONS
CREATE POLICY "Users can read own transactions" ON transactions FOR SELECT USING (auth.uid() = user_id);

-- NOTIFICATIONS
CREATE POLICY "Users can read own notifications" ON notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own notifications" ON notifications FOR UPDATE USING (auth.uid() = user_id);

-- FEED_EVENTS
CREATE POLICY "Users can read visible feed events" ON feed_events FOR SELECT
  USING (visibility = 'public' OR (visibility = 'private' AND (auth.uid() = user_id OR EXISTS (SELECT 1 FROM pack_members WHERE pack_id = feed_events.pack_id AND user_id = auth.uid() AND role = 'admin'))) OR (visibility = 'pack' AND EXISTS (SELECT 1 FROM pack_members WHERE pack_id = feed_events.pack_id AND user_id = auth.uid() AND is_active = true)));

-- PHONE_JAILS
CREATE POLICY "Users can read own phone jails" ON phone_jails FOR SELECT
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM pack_members WHERE pack_id = phone_jails.pack_id AND user_id = auth.uid() AND role = 'admin'));

-- PUNISHMENTS
CREATE POLICY "Pack admins can read punishments" ON punishments FOR SELECT
  USING (EXISTS (SELECT 1 FROM pack_members WHERE pack_id = punishments.pack_id AND user_id = auth.uid() AND role = 'admin'));

-- REACTIONS
CREATE POLICY "Pack members can read reactions" ON reactions FOR SELECT
  USING (EXISTS (SELECT 1 FROM pack_members pm LEFT JOIN feed_events fe ON pm.pack_id = fe.pack_id LEFT JOIN check_ins ci ON pm.pack_id = ci.pack_id WHERE pm.user_id = auth.uid() AND (reactions.feed_event_id = fe.id OR reactions.check_in_id = ci.id)));

CREATE POLICY "Users can create reactions" ON reactions FOR INSERT WITH CHECK (auth.uid() = user_id);

-- COMMENTS
CREATE POLICY "Pack members can read comments" ON comments FOR SELECT
  USING (EXISTS (SELECT 1 FROM pack_members pm LEFT JOIN feed_events fe ON pm.pack_id = fe.pack_id LEFT JOIN check_ins ci ON pm.pack_id = ci.pack_id WHERE pm.user_id = auth.uid() AND (comments.feed_event_id = fe.id OR comments.check_in_id = ci.id)));

CREATE POLICY "Users can create comments" ON comments FOR INSERT WITH CHECK (auth.uid() = user_id);

-- USER_POWERUPS
CREATE POLICY "Users can read own powerups" ON user_powerups FOR SELECT USING (auth.uid() = user_id);

-- CHALLENGE_ROOMS
CREATE POLICY "Users can read all challenges" ON challenge_rooms FOR SELECT USING (true);
CREATE POLICY "Creators can update challenges" ON challenge_rooms FOR UPDATE USING (auth.uid() = creator_id);

-- CHALLENGE_PARTICIPANTS
CREATE POLICY "Users can read challenge participation" ON challenge_participants FOR SELECT USING (auth.uid() = user_id OR true);
CREATE POLICY "Users can participate in challenges" ON challenge_participants FOR INSERT WITH CHECK (auth.uid() = user_id);

-- REPUTATION_LOG
CREATE POLICY "Users can read own reputation history" ON reputation_log FOR SELECT USING (auth.uid() = voter_id);

-- POWERUPS
CREATE POLICY "Everyone can read powerups" ON powerups FOR SELECT USING (true);

-- Migration 013: Real-time Setup
-- Enable real-time subscriptions for live feed, notifications, and voting

DROP PUBLICATION IF EXISTS pakkt_realtime CASCADE;
CREATE PUBLICATION pakkt_realtime FOR TABLE
  feed_events,
  check_ins,
  fine_votes,
  notifications,
  fines,
  reactions,
  comments,
  phone_jails;

COMMENT ON PUBLICATION pakkt_realtime IS 'Real-time publication for live updates to feed, notifications, and voting';

GRANT SELECT ON feed_events TO authenticated;
GRANT SELECT ON check_ins TO authenticated;
GRANT SELECT ON fine_votes TO authenticated;
GRANT SELECT ON notifications TO authenticated;
GRANT SELECT ON fines TO authenticated;
GRANT SELECT ON reactions TO authenticated;
GRANT SELECT ON comments TO authenticated;
GRANT SELECT ON phone_jails TO authenticated;

CREATE OR REPLACE FUNCTION on_auth_user_created()
RETURNS TRIGGER AS $$
DECLARE
  default_username text;
BEGIN

  -- insert user record; explicitly list columns and values
  INSERT INTO public.users (
    id,
    username,
    xp,
    level,
    coins,
    streak_count,
    phone_jail_opt_in,
    created_at,
    updated_at,
    last_active
  ) VALUES (
    NEW.id,
    '',
    0,
    1,
    0,
    0,
    false,
    now(),
    now(),
    now()
  )
  ON CONFLICT (id) DO NOTHING; -- avoid errors if user already exists

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- revoke execution from public and authenticated roles (example)
REVOKE EXECUTE ON FUNCTION on_auth_user_created() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION on_auth_user_created() FROM authenticated;
-- grant to the specific role that needs it if required, or keep only owner/service_role having execute

CREATE TRIGGER on_auth_user_created_trigger
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION on_auth_user_created();


  -- Add missing INSERT policy for packs
  CREATE POLICY "Users can create packs" ON packs FOR INSERT
    WITH CHECK (auth.uid() = creator_id);

  -- Create fixed pack_members policies without recursion
  CREATE POLICY "Users can read own pack memberships" ON pack_members FOR SELECT
    USING (auth.uid() = user_id);

  CREATE POLICY "Users can read pack memberships they belong to" ON pack_members FOR SELECT
    USING (EXISTS (
      SELECT 1 FROM packs p
      WHERE p.id = pack_members.pack_id
      AND p.creator_id = auth.uid()
    ));

  CREATE POLICY "Pack creators can manage members" ON pack_members FOR ALL
    USING (EXISTS (
      SELECT 1 FROM packs p
      WHERE p.id = pack_members.pack_id
      AND p.creator_id = auth.uid()
    ));

  CREATE POLICY "Users can insert themselves as members" ON pack_members FOR INSERT
    WITH CHECK (auth.uid() = user_id);

    ALTER TABLE public.users ALTER COLUMN email DROP NOT NULL;
