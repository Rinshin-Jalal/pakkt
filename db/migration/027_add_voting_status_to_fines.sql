-- Migration 027: Add 'voting' status to fines check constraint
-- The code expects 'voting' status but DB constraint doesn't allow it

-- Drop old constraint
ALTER TABLE fines
DROP CONSTRAINT IF EXISTS fines_status_check;

-- Add new constraint with 'voting' status
ALTER TABLE fines
ADD CONSTRAINT fines_status_check
CHECK (status IN ('pending', 'voting', 'enforced', 'appealed', 'cancelled'));

COMMENT ON CONSTRAINT fines_status_check ON fines IS 'pending=created, voting=pack voting in progress, enforced=fine applied, appealed=under appeal, cancelled=dismissed';
