-- Migration 007: Punishments, transactions, powerups, and phone jails
-- Enforcement mechanisms, financial flows, and boosts

CREATE TABLE IF NOT EXISTS phone_jails (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  pack_id uuid NOT NULL REFERENCES packs(id) ON DELETE CASCADE,
  duration_minutes integer NOT NULL,
  blocked_apps text[], -- array of app bundle IDs
  started_at timestamp with time zone DEFAULT now() NOT NULL,
  ended_at timestamp with time zone,
  reason text, -- why they're in jail
  created_at timestamp with time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS punishments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  pack_id uuid NOT NULL REFERENCES packs(id) ON DELETE CASCADE,
  check_in_id uuid REFERENCES check_ins(id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('fine', 'jail')),
  amount integer NOT NULL, -- fine in cents or jail in minutes
  status text DEFAULT 'pending' NOT NULL CHECK (status IN ('pending', 'served', 'appealed', 'cancelled')),
  enforced_by uuid REFERENCES users(id) ON DELETE SET NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  completed_at timestamp with time zone
);

CREATE TABLE IF NOT EXISTS transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  pack_id uuid REFERENCES packs(id) ON DELETE SET NULL,
  type text NOT NULL CHECK (type IN ('fine_payment', 'reward_payout', 'powerup_purchase')),
  amount integer NOT NULL, -- in cents
  provider text CHECK (provider IN ('stripe', 'cashapp', 'venmo')),
  status text DEFAULT 'pending' NOT NULL CHECK (status IN ('pending', 'success', 'failed')),
  external_id text, -- transaction ID from payment provider
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  completed_at timestamp with time zone
);

CREATE TABLE IF NOT EXISTS powerups (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  description text,
  rarity text DEFAULT 'common' CHECK (rarity IN ('common', 'rare', 'epic')),
  cost integer NOT NULL, -- in cents
  duration_seconds integer, -- NULL if permanent
  created_at timestamp with time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS user_powerups (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  powerup_id uuid NOT NULL REFERENCES powerups(id) ON DELETE CASCADE,
  status text DEFAULT 'active' NOT NULL CHECK (status IN ('active', 'expired', 'used')),
  obtained_at timestamp with time zone DEFAULT now() NOT NULL,
  expires_at timestamp with time zone,
  used_at timestamp with time zone
);

-- Indexes
CREATE INDEX idx_phone_jails_user_id ON phone_jails(user_id);
CREATE INDEX idx_phone_jails_pack_id ON phone_jails(pack_id);
CREATE INDEX idx_phone_jails_started_at ON phone_jails(started_at);

CREATE INDEX idx_punishments_user_id ON punishments(user_id);
CREATE INDEX idx_punishments_pack_id ON punishments(pack_id);
CREATE INDEX idx_punishments_status ON punishments(status);
CREATE INDEX idx_punishments_type ON punishments(type);

CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_pack_id ON transactions(pack_id);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_type ON transactions(type);
CREATE INDEX idx_transactions_created_at ON transactions(created_at);

CREATE INDEX idx_user_powerups_user_id ON user_powerups(user_id);
CREATE INDEX idx_user_powerups_status ON user_powerups(status);

COMMENT ON TABLE phone_jails IS 'Screen time lock sessions triggered by missed check-ins or fines.';
COMMENT ON TABLE punishments IS 'Executed consequences (fines or jail) from failed check-ins.';
COMMENT ON TABLE transactions IS 'Financial flows: fine payments, reward payouts, power-up purchases.';
COMMENT ON TABLE powerups IS 'Purchasable or earned boosts: shield, double XP, reverse jail, etc.';
COMMENT ON TABLE user_powerups IS 'Inventory of acquired power-ups with active/expired/used status.';

