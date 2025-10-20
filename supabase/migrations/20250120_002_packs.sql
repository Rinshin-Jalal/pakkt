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

