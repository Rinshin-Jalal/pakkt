-- Migration 030: Fix infinite recursion in fine_votes SELECT policy
-- Purpose: The SELECT policy was querying fine_votes table within fine_votes policy causing recursion
-- Date: 2025-10-24

-- Drop the broken SELECT policy
DROP POLICY IF EXISTS "Pack members can read fine votes" ON fine_votes;

-- Create corrected SELECT policy (no recursion)
CREATE POLICY "Pack members can read fine votes" ON fine_votes
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM fines f
      JOIN pack_members pm ON f.pack_id = pm.pack_id
      WHERE f.id = fine_votes.fine_id
        AND pm.user_id = auth.uid()
        AND pm.is_active = true
    )
  );

COMMENT ON POLICY "Pack members can read fine votes" ON fine_votes IS
  'Allows pack members to see votes on fines in their packs (fixed recursion)';

-- Also add missing INSERT policy for notifications (from earlier fix)
DROP POLICY IF EXISTS "pack_members_can_create_notifications" ON notifications;

CREATE POLICY "pack_members_can_create_notifications" ON notifications
  FOR INSERT
  WITH CHECK (true);

COMMENT ON POLICY "pack_members_can_create_notifications" ON notifications IS
  'Allows creating notifications - primarily for database triggers (on_fine_created, etc)';
