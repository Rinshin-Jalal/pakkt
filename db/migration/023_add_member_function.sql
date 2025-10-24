-- Migration 023: Create function to add pack members (bypasses RLS)
-- This allows the application to add members after verifying permissions in code

CREATE OR REPLACE FUNCTION add_pack_member(
  p_pack_id uuid,
  p_user_id uuid,
  p_role text DEFAULT 'member'
)
RETURNS TABLE (
  id uuid,
  pack_id uuid,
  user_id uuid,
  role text,
  join_date timestamptz,
  reputation_xp integer,
  is_active boolean,
  created_at timestamptz,
  updated_at timestamptz
)
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  -- Insert the member
  RETURN QUERY
  INSERT INTO pack_members (pack_id, user_id, role, reputation_xp, is_active)
  VALUES (p_pack_id, p_user_id, p_role, 0, true)
  RETURNING
    pack_members.id,
    pack_members.pack_id,
    pack_members.user_id,
    pack_members.role,
    pack_members.join_date,
    pack_members.reputation_xp,
    pack_members.is_active,
    pack_members.created_at,
    pack_members.updated_at;
END;
$$;
