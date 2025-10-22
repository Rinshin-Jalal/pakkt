-- Migration 015: Fix RLS infinite recursion in packs table
-- Purpose: Remove circular dependency between packs and pack_members policies

-- Drop all existing packs policies
DROP POLICY IF EXISTS "Users can read packs they're in" ON packs;
DROP POLICY IF EXISTS "Pack admins can update pack" ON packs;
DROP POLICY IF EXISTS "Only creator can delete pack" ON packs;
DROP POLICY IF EXISTS "Users can create packs" ON packs;

-- Recreate non-recursive packs policies

-- 1) Users can create packs (simple, no recursion)
CREATE POLICY "Users can create packs" ON packs FOR INSERT
  WITH CHECK (auth.uid() = creator_id);

-- 2) Users can read packs they created (no recursion)
CREATE POLICY "Pack creators can read their packs" ON packs FOR SELECT
  USING (auth.uid() = creator_id);

-- 3) Pack members can read packs (uses pack_members but that's ok for SELECT)
-- Note: This won't cause recursion because pack_members SELECT policies
-- only query the packs table, they don't check pack_members policies
CREATE POLICY "Pack members can read packs" ON packs FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM pack_members pm
      WHERE pm.pack_id = packs.id
        AND pm.user_id = auth.uid()
        AND pm.is_active = true
    )
  );

-- 4) Only pack creator can update pack (no recursion)
CREATE POLICY "Pack creators can update pack" ON packs FOR UPDATE
  USING (auth.uid() = creator_id);

-- 5) Only pack creator can delete pack (no recursion)
CREATE POLICY "Pack creators can delete pack" ON packs FOR DELETE
  USING (auth.uid() = creator_id);
