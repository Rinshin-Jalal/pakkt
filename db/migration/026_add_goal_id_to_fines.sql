-- Migration 026: Add goal_id column to fines table
-- Fines need to reference which goal was missed

-- Add goal_id column
ALTER TABLE fines
ADD COLUMN IF NOT EXISTS goal_id uuid;

-- Add foreign key constraint
ALTER TABLE fines
ADD CONSTRAINT fines_goal_id_fkey
FOREIGN KEY (goal_id)
REFERENCES goals(id)
ON DELETE CASCADE;

-- Add index for performance
CREATE INDEX IF NOT EXISTS idx_fines_goal_id ON fines(goal_id);

-- Make check_in_id nullable since fines can be created without a check-in
ALTER TABLE fines
ALTER COLUMN check_in_id DROP NOT NULL;

COMMENT ON COLUMN fines.goal_id IS 'The goal that was missed, triggering this fine';
