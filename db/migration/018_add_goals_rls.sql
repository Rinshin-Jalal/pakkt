-- Migration 018: Add RLS policies for goals table
-- Purpose: Allow users to create and manage goals

-- Drop any existing goals policies
DROP POLICY IF EXISTS "Pack members can read goals" ON goals;
DROP POLICY IF EXISTS "Pack admins can manage goals" ON goals;
DROP POLICY IF EXISTS "Goal creator can delete" ON goals;

-- Create simple, non-recursive policies for goals

-- Allow users to insert goals they created
CREATE POLICY "goals_insert_own" ON goals FOR INSERT
  WITH CHECK (auth.uid() = creator_id);

-- Allow users to read goals they created
CREATE POLICY "goals_select_creator" ON goals FOR SELECT
  USING (auth.uid() = creator_id);

-- Allow users to update goals they created
CREATE POLICY "goals_update_creator" ON goals FOR UPDATE
  USING (auth.uid() = creator_id);

-- Allow users to delete goals they created
CREATE POLICY "goals_delete_creator" ON goals FOR DELETE
  USING (auth.uid() = creator_id);
