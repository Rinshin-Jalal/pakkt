-- Migration 017: Complete RLS recursion fix
-- Purpose: Remove ALL circular dependencies between packs and pack_members

-- ============================================================================
-- DROP ALL EXISTING POLICIES
-- ============================================================================

-- Drop all packs policies
DROP POLICY IF EXISTS "Users can read packs they're in" ON packs;
DROP POLICY IF EXISTS "Pack admins can update pack" ON packs;
DROP POLICY IF EXISTS "Only creator can delete pack" ON packs;
DROP POLICY IF EXISTS "Users can create packs" ON packs;
DROP POLICY IF EXISTS "Pack creators can read their packs" ON packs;
DROP POLICY IF EXISTS "Pack members can read packs" ON packs;
DROP POLICY IF EXISTS "Pack creators can update pack" ON packs;
DROP POLICY IF EXISTS "Pack creators can delete pack" ON packs;

-- Drop all pack_members policies
DROP POLICY IF EXISTS "Users can read their pack memberships" ON pack_members;
DROP POLICY IF EXISTS "Admins can update pack members" ON pack_members;
DROP POLICY IF EXISTS "Users can read own pack memberships" ON pack_members;
DROP POLICY IF EXISTS "Pack creators can read pack memberships" ON pack_members;
DROP POLICY IF EXISTS "Pack creators can read memberships" ON pack_members;
DROP POLICY IF EXISTS "Pack creators can insert members" ON pack_members;
DROP POLICY IF EXISTS "Users can insert themselves as members" ON pack_members;
DROP POLICY IF EXISTS "Users can insert themselves" ON pack_members;
DROP POLICY IF EXISTS "Pack creators can update members" ON pack_members;
DROP POLICY IF EXISTS "Pack creators can delete members" ON pack_members;
DROP POLICY IF EXISTS "Users can read pack memberships they belong to" ON pack_members;
DROP POLICY IF EXISTS "Pack creators can manage members" ON pack_members;

-- ============================================================================
-- CREATE NON-RECURSIVE PACKS POLICIES
-- ============================================================================

-- Allow users to create packs they own
CREATE POLICY "packs_insert_own" ON packs FOR INSERT
  WITH CHECK (auth.uid() = creator_id);

-- Allow users to read packs they created (NO pack_members reference)
CREATE POLICY "packs_select_creator" ON packs FOR SELECT
  USING (auth.uid() = creator_id);

-- Allow pack creators to update their packs (NO pack_members reference)
CREATE POLICY "packs_update_creator" ON packs FOR UPDATE
  USING (auth.uid() = creator_id);

-- Allow pack creators to delete their packs (NO pack_members reference)
CREATE POLICY "packs_delete_creator" ON packs FOR DELETE
  USING (auth.uid() = creator_id);

-- ============================================================================
-- CREATE NON-RECURSIVE PACK_MEMBERS POLICIES
-- ============================================================================

-- Allow users to read their own memberships (NO packs reference)
CREATE POLICY "pack_members_select_own" ON pack_members FOR SELECT
  USING (auth.uid() = user_id);

-- Allow users to insert themselves as members (NO packs reference)
CREATE POLICY "pack_members_insert_self" ON pack_members FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- IMPORTANT: NO CROSS-TABLE REFERENCES IN RLS POLICIES
-- ============================================================================
-- The policies above are intentionally simple and DO NOT reference other tables.
-- All permission checks that require checking both packs and pack_members
-- should be done in application code, NOT in RLS policies.
-- This completely eliminates the possibility of infinite recursion.
