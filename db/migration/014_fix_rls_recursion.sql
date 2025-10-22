-- Migration 014: Fix RLS infinite recursion in pack_members
-- Purpose: Remove circular dependencies in pack_members policies

-- Drop ALL existing pack_members policies
DROP POLICY IF EXISTS "Users can read their pack memberships" ON pack_members;
DROP POLICY IF EXISTS "Admins can update pack members" ON pack_members;
DROP POLICY IF EXISTS "Users can read own pack memberships" ON pack_members;
DROP POLICY IF EXISTS "Pack creators can read pack memberships" ON pack_members;
DROP POLICY IF EXISTS "Pack creators can update members" ON pack_members;
DROP POLICY IF EXISTS "Pack creators can delete members" ON pack_members;
DROP POLICY IF EXISTS "Users can insert themselves as members" ON pack_members;
DROP POLICY IF EXISTS "Users can read pack memberships they belong to" ON pack_members;
DROP POLICY IF EXISTS "Pack creators can manage members" ON pack_members;

-- Recreate non-recursive policies

-- 1) Users can read their own memberships (no recursion)
CREATE POLICY "Users can read own memberships" ON pack_members FOR SELECT
  USING (auth.uid() = user_id);

-- 2) Pack creators can read memberships for their packs (no self-reference to pack_members)
CREATE POLICY "Pack creators can read memberships" ON pack_members FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM packs p
      WHERE p.id = pack_members.pack_id
        AND p.creator_id = auth.uid()
    )
  );

-- 3) Pack creators can insert members (no self-reference)
CREATE POLICY "Pack creators can insert members" ON pack_members FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM packs p
      WHERE p.id = pack_id
        AND p.creator_id = auth.uid()
    )
  );

-- 4) Users can insert themselves as members
CREATE POLICY "Users can insert themselves" ON pack_members FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- 5) Pack creators can update members (no self-reference)
CREATE POLICY "Pack creators can update members" ON pack_members FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM packs p
      WHERE p.id = pack_members.pack_id
        AND p.creator_id = auth.uid()
    )
  );

-- 6) Pack creators can delete members (no self-reference)
CREATE POLICY "Pack creators can delete members" ON pack_members FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM packs p
      WHERE p.id = pack_members.pack_id
        AND p.creator_id = auth.uid()
    )
  );
