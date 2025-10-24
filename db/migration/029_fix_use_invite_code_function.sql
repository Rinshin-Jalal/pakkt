-- Migration 029: Fix use_invite_code function to return pack details
-- Purpose: The function now returns pack data directly to avoid RLS issues
-- Issue: After adding user to pack, they couldn't read pack details due to RLS
-- Solution: SECURITY DEFINER function returns data directly

-- Drop old function
DROP FUNCTION IF EXISTS use_invite_code(text, uuid);

-- Create new function that returns pack and member details
CREATE OR REPLACE FUNCTION use_invite_code(p_code text, p_user_id uuid)
RETURNS TABLE(
  result_pack_id uuid,
  result_pack_name text,
  result_pack_creator_id uuid,
  result_pack_xp integer,
  result_pack_level integer,
  result_pack_status text,
  result_member_id uuid,
  result_member_role text,
  result_member_reputation_xp integer
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_invite_code pack_invite_codes;
  v_pack_id uuid;
  v_member_id uuid;
BEGIN
  -- Get and lock the invite code
  SELECT * INTO v_invite_code
  FROM pack_invite_codes
  WHERE code = p_code
    AND is_active = true
    AND expires_at > now()
    AND current_uses < max_uses
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invalid or expired invite code';
  END IF;

  v_pack_id := v_invite_code.pack_id;

  -- Check if user is already a member
  IF EXISTS (
    SELECT 1 FROM pack_members pm2
    WHERE pm2.pack_id = v_pack_id AND pm2.user_id = p_user_id
  ) THEN
    RAISE EXCEPTION 'User is already a member of this pack';
  END IF;

  -- Add user to pack
  INSERT INTO pack_members (pack_id, user_id, role, reputation_xp, is_active)
  VALUES (v_pack_id, p_user_id, 'member', 0, true)
  RETURNING id INTO v_member_id;

  -- Increment usage count
  UPDATE pack_invite_codes
  SET current_uses = current_uses + 1,
      updated_at = now()
  WHERE id = v_invite_code.id;

  -- Return pack and member details (bypasses RLS since SECURITY DEFINER)
  RETURN QUERY
  SELECT
    p.id,
    p.name,
    p.creator_id,
    p.xp,
    p.level,
    p.status,
    pm.id,
    pm.role,
    pm.reputation_xp
  FROM packs p
  INNER JOIN pack_members pm ON pm.pack_id = p.id
  WHERE p.id = v_pack_id AND pm.id = v_member_id;
END;
$$;

COMMENT ON FUNCTION use_invite_code IS 'Validates invite code, adds user to pack, and returns pack details (atomic operation, bypasses RLS)';
