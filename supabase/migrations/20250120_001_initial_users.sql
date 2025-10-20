-- Migration 001: Initial users table
-- This table stores every account and personal progression

CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  username text UNIQUE NOT NULL,
  email text UNIQUE NOT NULL,
  password_hash text NOT NULL,
  profile_pic text,
  bio text,
  xp integer DEFAULT 0 NOT NULL,
  level integer DEFAULT 1 NOT NULL,
  coins integer DEFAULT 0 NOT NULL,
  streak_count integer DEFAULT 0 NOT NULL,
  phone_jail_opt_in boolean DEFAULT false NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  last_active timestamp with time zone DEFAULT now()
);

-- Indexes for users table
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Comment for clarity
COMMENT ON TABLE users IS 'Stores every account and personal progression. Tracks XP, coins, streaks, and phone jail preferences.';
COMMENT ON COLUMN users.xp IS 'Total earned XP representing accountability score';
COMMENT ON COLUMN users.level IS 'Derived from XP tiers (dynamically calculated)';
COMMENT ON COLUMN users.coins IS 'In-app currency for power-ups';
COMMENT ON COLUMN users.streak_count IS 'Consecutive successful check-ins';
COMMENT ON COLUMN users.phone_jail_opt_in IS 'Whether user allows Screen Time blocking';

