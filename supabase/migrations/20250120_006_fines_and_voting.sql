-- Migration 006: Fines and voting tables
-- Democratic punishment system via peer voting

CREATE TABLE IF NOT EXISTS fines (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  check_in_id uuid NOT NULL REFERENCES check_ins(id) ON DELETE CASCADE,
  pack_id uuid NOT NULL REFERENCES packs(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  amount integer NOT NULL, -- in cents
  status text DEFAULT 'pending' NOT NULL CHECK (status IN ('pending', 'enforced', 'appealed', 'cancelled')),
  voting_ends_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS fine_votes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  fine_id uuid NOT NULL REFERENCES fines(id) ON DELETE CASCADE,
  voter_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  vote boolean NOT NULL, -- true = enforce, false = dismiss
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

-- Indexes for fines
CREATE INDEX idx_fines_check_in_id ON fines(check_in_id);
CREATE INDEX idx_fines_pack_id ON fines(pack_id);
CREATE INDEX idx_fines_user_id ON fines(user_id);
CREATE INDEX idx_fines_status ON fines(status);
CREATE INDEX idx_fines_created_at ON fines(created_at);

-- Indexes for fine_votes
CREATE INDEX idx_fine_votes_fine_id ON fine_votes(fine_id);
CREATE INDEX idx_fine_votes_voter_id ON fine_votes(voter_id);
CREATE INDEX idx_fine_votes_created_at ON fine_votes(created_at);

COMMENT ON TABLE fines IS 'Executed consequences from missed check-ins. Stored on-chain for voting and appeals.';
COMMENT ON COLUMN fines.status IS 'pending (voting), enforced (executed), appealed (disputed), or cancelled';
COMMENT ON COLUMN fines.voting_ends_at IS 'Timestamp when voting window closes';

COMMENT ON TABLE fine_votes IS 'Individual votes from pack members on whether to enforce a fine.';
COMMENT ON COLUMN fine_votes.vote IS 'true = yes enforce, false = no dismiss';

