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

