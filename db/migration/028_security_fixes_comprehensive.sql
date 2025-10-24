-- Migration 028: Comprehensive Security Fixes
-- Purpose: Fix all service role bypass issues identified in security audit
-- Date: 2025-10-24

-- ============================================================================
-- SECTION 1: PACK MEMBERS - Allow users to update their own XP
-- ============================================================================
-- Issue: Users can't update their own pack_members record (reputation_xp)
-- Currently: Using service role to bypass RLS after check-ins
-- Fix: Allow users to update their own pack_members record

DROP POLICY IF EXISTS "users_update_own_pack_stats" ON pack_members;

CREATE POLICY "users_update_own_pack_stats" ON pack_members
  FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

COMMENT ON POLICY "users_update_own_pack_stats" ON pack_members IS
  'Allows users to update their own pack_members record (e.g., reputation_xp after check-ins)';


-- ============================================================================
-- SECTION 2: INVITE CODES - Self-join system with expirable, limited-use codes
-- ============================================================================
-- Issue: Currently pack creators add members directly (requires service role)
-- Fix: Implement invite code system where users join themselves

CREATE TABLE IF NOT EXISTS pack_invite_codes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  pack_id uuid NOT NULL REFERENCES packs(id) ON DELETE CASCADE,
  code text UNIQUE NOT NULL,
  created_by uuid NOT NULL REFERENCES users(id),
  max_uses integer DEFAULT 1 NOT NULL CHECK (max_uses > 0),
  current_uses integer DEFAULT 0 NOT NULL CHECK (current_uses >= 0),
  expires_at timestamp with time zone NOT NULL,
  is_active boolean DEFAULT true NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

-- Indexes
CREATE INDEX idx_pack_invite_codes_code ON pack_invite_codes(code);
CREATE INDEX idx_pack_invite_codes_pack_id ON pack_invite_codes(pack_id);
CREATE INDEX idx_pack_invite_codes_expires_at ON pack_invite_codes(expires_at);

COMMENT ON TABLE pack_invite_codes IS 'Expirable, limited-use invite codes for pack membership';
COMMENT ON COLUMN pack_invite_codes.max_uses IS 'Maximum number of times this code can be used';
COMMENT ON COLUMN pack_invite_codes.current_uses IS 'Number of times this code has been used';
COMMENT ON COLUMN pack_invite_codes.expires_at IS 'Code becomes invalid after this timestamp';

-- RLS for invite codes
ALTER TABLE pack_invite_codes ENABLE ROW LEVEL SECURITY;

-- Anyone can read active, non-expired codes (to validate before joining)
CREATE POLICY "anyone_read_active_codes" ON pack_invite_codes
  FOR SELECT
  USING (
    is_active = true
    AND expires_at > now()
    AND current_uses < max_uses
  );

-- Pack creators can create invite codes for their packs
CREATE POLICY "pack_creators_create_codes" ON pack_invite_codes
  FOR INSERT
  WITH CHECK (
    created_by = auth.uid()
    AND pack_id IN (
      SELECT id FROM packs WHERE creator_id = auth.uid()
    )
  );

-- Pack creators can update their own codes
CREATE POLICY "pack_creators_update_codes" ON pack_invite_codes
  FOR UPDATE
  USING (
    pack_id IN (
      SELECT id FROM packs WHERE creator_id = auth.uid()
    )
  );

-- Function to validate and use invite code
CREATE OR REPLACE FUNCTION use_invite_code(p_code text, p_user_id uuid)
RETURNS TABLE(
  pack_id uuid,
  pack_name text,
  pack_creator_id uuid,
  pack_xp integer,
  pack_level integer,
  pack_status text,
  member_id uuid,
  member_role text,
  member_reputation_xp integer
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_invite_code pack_invite_codes;
  v_pack_id uuid;
  v_member_id uuid;
BEGIN
  -- Get and lock the invite code
  SELECT * INTO v_invite_code
  FROM pack_invite_codes
  WHERE code = p_code
    AND is_active = true
    AND expires_at > now()
    AND current_uses < max_uses
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invalid or expired invite code';
  END IF;

  v_pack_id := v_invite_code.pack_id;

  -- Check if user is already a member
  IF EXISTS (
    SELECT 1 FROM pack_members
    WHERE pack_id = v_pack_id AND user_id = p_user_id
  ) THEN
    RAISE EXCEPTION 'User is already a member of this pack';
  END IF;

  -- Add user to pack
  INSERT INTO pack_members (pack_id, user_id, role, reputation_xp, is_active)
  VALUES (v_pack_id, p_user_id, 'member', 0, true)
  RETURNING id INTO v_member_id;

  -- Increment usage count
  UPDATE pack_invite_codes
  SET current_uses = current_uses + 1,
      updated_at = now()
  WHERE id = v_invite_code.id;

  -- Return pack and member details (bypasses RLS since SECURITY DEFINER)
  RETURN QUERY
  SELECT
    p.id as pack_id,
    p.name as pack_name,
    p.creator_id as pack_creator_id,
    p.xp as pack_xp,
    p.level as pack_level,
    p.status as pack_status,
    pm.id as member_id,
    pm.role as member_role,
    pm.reputation_xp as member_reputation_xp
  FROM packs p
  JOIN pack_members pm ON pm.pack_id = p.id
  WHERE p.id = v_pack_id AND pm.id = v_member_id;
END;
$$;

COMMENT ON FUNCTION use_invite_code IS 'Validates invite code and adds user to pack (atomic operation)';


-- ============================================================================
-- SECTION 3: FINES - Allow pack members to create and resolve fines
-- ============================================================================
-- Issue: Service role used to create fines and resolve them
-- Fix: Add RLS policies for pack members

DROP POLICY IF EXISTS "pack_members_create_fines" ON fines;
DROP POLICY IF EXISTS "pack_members_update_fines" ON fines;

-- Pack members can create fines in their packs
CREATE POLICY "pack_members_create_fines" ON fines
  FOR INSERT
  WITH CHECK (
    pack_id IN (
      SELECT pack_id FROM pack_members
      WHERE user_id = auth.uid() AND is_active = true
    )
  );

-- Pack members can update fines in their packs (for resolution)
CREATE POLICY "pack_members_update_fines" ON fines
  FOR UPDATE
  USING (
    pack_id IN (
      SELECT pack_id FROM pack_members
      WHERE user_id = auth.uid() AND is_active = true
    )
  );

COMMENT ON POLICY "pack_members_create_fines" ON fines IS
  'Allows pack members to create fines for missed check-ins';
COMMENT ON POLICY "pack_members_update_fines" ON fines IS
  'Allows pack members to update/resolve fines after voting';


-- ============================================================================
-- SECTION 4: FINE VOTES - Prevent race condition (multiple votes)
-- ============================================================================
-- Issue: Users can vote multiple times by sending concurrent requests
-- Fix: Add unique constraint at database level

-- Add unique constraint to prevent duplicate votes
ALTER TABLE fine_votes
  DROP CONSTRAINT IF EXISTS fine_votes_user_unique;

ALTER TABLE fine_votes
  ADD CONSTRAINT fine_votes_user_unique UNIQUE (fine_id, voter_id);

COMMENT ON CONSTRAINT fine_votes_user_unique ON fine_votes IS
  'Prevents race condition - users can only vote once per fine';


-- ============================================================================
-- SECTION 5: GOALS - Ensure pack members can read goals (verify existing)
-- ============================================================================
-- Already exists in migration 020, but verifying it's in place

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'goals'
    AND policyname = 'goals_select_pack_goals_simple'
  ) THEN
    CREATE POLICY "goals_select_pack_goals_simple" ON goals
      FOR SELECT
      USING (goal_type = 'pack');
  END IF;
END $$;


-- ============================================================================
-- SECTION 6: CLEANUP - Drop old functions no longer needed
-- ============================================================================
-- The add_pack_member function is no longer needed with invite codes
-- Keep it for backward compatibility but document it's deprecated

COMMENT ON FUNCTION add_pack_member IS
  'DEPRECATED: Use invite codes (use_invite_code function) instead';


-- ============================================================================
-- VERIFICATION QUERIES (for testing)
-- ============================================================================
-- Run these to verify policies are working:

-- 1. Check pack_members UPDATE policy
-- SELECT * FROM pg_policies WHERE tablename = 'pack_members' AND cmd = 'UPDATE';

-- 2. Check invite codes table
-- SELECT table_name FROM information_schema.tables WHERE table_name = 'pack_invite_codes';

-- 3. Check fines policies
-- SELECT policyname FROM pg_policies WHERE tablename = 'fines';

-- 4. Check fine_votes unique constraint
-- SELECT constraint_name FROM information_schema.table_constraints
-- WHERE table_name = 'fine_votes' AND constraint_type = 'UNIQUE';


-- ============================================================================
-- MIGRATION COMPLETE
-- ============================================================================
-- Summary:
-- ✅ Users can update their own pack_members XP (no service role needed)
-- ✅ Invite code system with expiry and usage limits (self-join)
-- ✅ Pack members can create and resolve fines (no service role needed)
-- ✅ Race condition prevented with unique constraint on fine_votes
-- ✅ All service role usage eliminated except for system functions
