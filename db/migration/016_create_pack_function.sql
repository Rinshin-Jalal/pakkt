-- Migration 016: Create database function for pack creation to bypass RLS recursion
-- Purpose: Create pack and add creator as member in a single transaction, bypassing RLS

CREATE OR REPLACE FUNCTION create_pack_with_creator(
  p_name text,
  p_creator_id uuid,
  p_goal_type text DEFAULT 'general'
)
RETURNS TABLE(
  id uuid,
  name text,
  creator_id uuid,
  goal_type text,
  status text,
  xp integer,
  level integer,
  created_at timestamp with time zone,
  updated_at timestamp with time zone,
  last_activity timestamp with time zone
)
SECURITY DEFINER -- Run with function owner's permissions, bypassing RLS
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
  v_pack_id uuid;
  v_pack record;
BEGIN
  -- Insert pack
  INSERT INTO packs (name, creator_id, goal_type, status, xp, level)
  VALUES (p_name, p_creator_id, p_goal_type, 'active', 0, 1)
  RETURNING * INTO v_pack;

  v_pack_id := v_pack.id;

  -- Insert creator as admin member
  INSERT INTO pack_members (pack_id, user_id, role, reputation_xp, is_active)
  VALUES (v_pack_id, p_creator_id, 'admin', 0, true);

  -- Return the pack
  RETURN QUERY
  SELECT
    v_pack.id,
    v_pack.name,
    v_pack.creator_id,
    v_pack.goal_type,
    v_pack.status,
    v_pack.xp,
    v_pack.level,
    v_pack.created_at,
    v_pack.updated_at,
    v_pack.last_activity;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION create_pack_with_creator(text, uuid, text) TO authenticated;

COMMENT ON FUNCTION create_pack_with_creator IS 'Creates a pack and adds the creator as admin member in a single transaction, bypassing RLS recursion issues';
