-- Migration 019: Support personal and pack goals
-- Purpose: Allow both pack-wide goals (admin only) and personal goals (any member)

-- Add goal_type column to distinguish personal vs pack goals
ALTER TABLE goals ADD COLUMN IF NOT EXISTS goal_type text DEFAULT 'personal' CHECK (goal_type IN ('personal', 'pack'));

-- Add assigned_to_user_id for personal goals (null for pack goals that apply to everyone)
ALTER TABLE goals ADD COLUMN IF NOT EXISTS assigned_to_user_id uuid REFERENCES users(id) ON DELETE CASCADE;

-- Add comment for clarity
COMMENT ON COLUMN goals.goal_type IS 'Type of goal: "personal" (created by member for self) or "pack" (created by admin for all members)';
COMMENT ON COLUMN goals.assigned_to_user_id IS 'For personal goals: the user this goal is assigned to. NULL for pack goals (applies to all members)';

-- Drop existing policies
DROP POLICY IF EXISTS "goals_insert_own" ON goals;
DROP POLICY IF EXISTS "goals_select_creator" ON goals;
DROP POLICY IF EXISTS "goals_update_creator" ON goals;
DROP POLICY IF EXISTS "goals_delete_creator" ON goals;

-- ============================================================================
-- RLS POLICIES FOR GOALS
-- ============================================================================

-- INSERT: Pack members can create personal goals for themselves
CREATE POLICY "goals_insert_personal" ON goals FOR INSERT
  WITH CHECK (
    goal_type = 'personal'
    AND auth.uid() = creator_id
    AND auth.uid() = assigned_to_user_id
  );

-- INSERT: Pack creators can create pack goals (admin-only, applies to all members)
-- Note: We check creator_id matches auth.uid(), not checking pack_members to avoid recursion
CREATE POLICY "goals_insert_pack_by_creator" ON goals FOR INSERT
  WITH CHECK (
    goal_type = 'pack'
    AND auth.uid() = creator_id
    AND assigned_to_user_id IS NULL
  );

-- SELECT: Users can see goals they created (both personal and pack)
CREATE POLICY "goals_select_creator" ON goals FOR SELECT
  USING (auth.uid() = creator_id);

-- SELECT: Users can see personal goals assigned to them
CREATE POLICY "goals_select_assigned" ON goals FOR SELECT
  USING (
    goal_type = 'personal'
    AND auth.uid() = assigned_to_user_id
  );

-- UPDATE: Only goal creator can update
CREATE POLICY "goals_update_creator" ON goals FOR UPDATE
  USING (auth.uid() = creator_id);

-- DELETE: Only goal creator can delete
CREATE POLICY "goals_delete_creator" ON goals FOR DELETE
  USING (auth.uid() = creator_id);

-- Create index for performance
CREATE INDEX IF NOT EXISTS idx_goals_goal_type ON goals(goal_type);
CREATE INDEX IF NOT EXISTS idx_goals_assigned_to_user_id ON goals(assigned_to_user_id) WHERE assigned_to_user_id IS NOT NULL;
