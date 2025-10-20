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

