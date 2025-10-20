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

