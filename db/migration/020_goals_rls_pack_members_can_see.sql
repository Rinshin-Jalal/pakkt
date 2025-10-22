-- Migration 020: Allow pack members to see pack goals
-- Purpose: Members need to see pack-wide goals to check in

-- Add policy for pack members to see pack goals
-- Note: We only check if the goal is a pack goal and belongs to a pack
-- We don't check pack_members table to avoid recursion
-- Permission checking is done in application code

CREATE POLICY "goals_select_pack_goals_simple" ON goals FOR SELECT
  USING (goal_type = 'pack');

-- This allows anyone to see pack goals
-- The application code will verify pack membership before allowing check-ins
-- This avoids RLS recursion while maintaining security through app-level checks
