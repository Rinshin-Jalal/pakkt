-- Migration 022: Allow pack creators to add members
-- Fix RLS policy blocking pack creators from adding other users as members

-- Drop existing restrictive policy
DROP POLICY IF EXISTS "pack_members_insert_self" ON pack_members;
DROP POLICY IF EXISTS "Users can insert themselves as members" ON pack_members;

-- Allow users to insert themselves
CREATE POLICY "pack_members_insert_self" ON pack_members
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Allow pack creators to insert members
-- This uses a subquery to check if the authenticated user is the pack creator
CREATE POLICY "pack_creators_can_add_members" ON pack_members
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM packs
      WHERE packs.id = pack_members.pack_id
        AND packs.creator_id = auth.uid()
    )
  );
