-- Migration 031: Create push_tokens table
-- Stores device tokens for push notifications

CREATE TABLE IF NOT EXISTS push_tokens (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token text NOT NULL UNIQUE,
  device_type text NOT NULL CHECK (device_type IN ('ios', 'android')), -- ios or android
  device_id text, -- optional device identifier
  is_active boolean DEFAULT true NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  UNIQUE(user_id, token)
);

-- Indexes for push_tokens table
CREATE INDEX idx_push_tokens_user_id ON push_tokens(user_id);
CREATE INDEX idx_push_tokens_token ON push_tokens(token);
CREATE INDEX idx_push_tokens_is_active ON push_tokens(is_active);
CREATE INDEX idx_push_tokens_device_type ON push_tokens(device_type);

-- Update timestamp trigger for push_tokens
CREATE TRIGGER update_push_tokens_timestamp BEFORE UPDATE ON push_tokens FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- RLS Policy for push_tokens
CREATE POLICY "Users can manage their own push tokens" ON push_tokens FOR ALL
  USING (auth.uid() = user_id);

COMMENT ON TABLE push_tokens IS 'Stores device tokens for push notifications. Links users to their notification endpoints.';
COMMENT ON COLUMN push_tokens.token IS 'Push notification token (APNs or FCM)';
COMMENT ON COLUMN push_tokens.device_type IS 'Device platform: ios or android';
COMMENT ON COLUMN push_tokens.device_id IS 'Unique device identifier (optional)';
COMMENT ON COLUMN push_tokens.is_active IS 'Whether this token is still valid (false if token rejected by service)';