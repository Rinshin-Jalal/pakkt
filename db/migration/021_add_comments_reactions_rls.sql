-- Migration 021: Add RLS policies for comments and reactions UPDATE/DELETE operations
-- Allows users to edit/delete their own comments and reactions

-- Comments UPDATE policy - users can only update their own comments
CREATE POLICY "Users can update own comments" ON comments
  FOR UPDATE
  USING (auth.uid() = user_id);

-- Comments DELETE policy - users can only delete their own comments
CREATE POLICY "Users can delete own comments" ON comments
  FOR DELETE
  USING (auth.uid() = user_id);

-- Reactions UPDATE policy - users can only update their own reactions
CREATE POLICY "Users can update own reactions" ON reactions
  FOR UPDATE
  USING (auth.uid() = user_id);

-- Reactions DELETE policy - users can only delete their own reactions
CREATE POLICY "Users can delete own reactions" ON reactions
  FOR DELETE
  USING (auth.uid() = user_id);
