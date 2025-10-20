-- Migration 005: Check-ins table
-- Daily evidence of goal completion with streak tracking

CREATE TABLE IF NOT EXISTS check_ins (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  goal_id uuid NOT NULL REFERENCES goals(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  pack_id uuid NOT NULL REFERENCES packs(id) ON DELETE CASCADE,
  status text DEFAULT 'pending_vote' NOT NULL CHECK (status IN ('success', 'missed', 'pending_vote')),
  proof_url text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  verified_at timestamp with time zone,
  xp_awarded integer DEFAULT 0,
  updated_at timestamp with time zone DEFAULT now()
);

-- Indexes for check_ins
CREATE INDEX idx_check_ins_goal_id ON check_ins(goal_id);
CREATE INDEX idx_check_ins_user_id ON check_ins(user_id);
CREATE INDEX idx_check_ins_pack_id ON check_ins(pack_id);
CREATE INDEX idx_check_ins_status ON check_ins(status);
CREATE INDEX idx_check_ins_created_at ON check_ins(created_at);
CREATE INDEX idx_check_ins_pack_user_date ON check_ins(pack_id, user_id, created_at DESC);

COMMENT ON TABLE check_ins IS 'Daily submissions of goal completion with media proof and streak data.';
COMMENT ON COLUMN check_ins.status IS 'success (verified), missed (flagged), or pending_vote (awaiting pack decision)';
COMMENT ON COLUMN check_ins.proof_url IS 'Media URL (photo/video) if proof_required=true on goal';
COMMENT ON COLUMN check_ins.xp_awarded IS 'XP gained on verification (0 until resolved)';

