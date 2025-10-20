-- Migration 009: Database functions
-- Reusable, atomic operations for core business logic

CREATE OR REPLACE FUNCTION calculate_streak(p_user_id uuid, p_pack_id uuid)
RETURNS integer AS $$
DECLARE
  v_streak integer := 0;
  v_last_date date;
BEGIN
  FOR v_last_date IN
    SELECT DISTINCT DATE(created_at)
    FROM check_ins
    WHERE user_id = p_user_id 
      AND pack_id = p_pack_id 
      AND status = 'success'
    ORDER BY DATE(created_at) DESC
  LOOP
    IF v_last_date = CURRENT_DATE - (v_streak || ' days')::interval THEN
      v_streak := v_streak + 1;
    ELSE
      EXIT;
    END IF;
  END LOOP;
  
  RETURN v_streak;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calculate_user_level(p_xp integer)
RETURNS integer AS $$
BEGIN
  RETURN GREATEST(1, (p_xp / 100) + 1);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calculate_pack_level(p_xp integer)
RETURNS integer AS $$
BEGIN
  RETURN GREATEST(1, (p_xp / 500) + 1);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calculate_vote_weight(p_reputation_xp integer)
RETURNS numeric AS $$
BEGIN
  RETURN LEAST(2.0, GREATEST(0.5, 1.0 + (p_reputation_xp::numeric / 500.0)));
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION detect_cheating(p_user_id uuid, p_goal_id uuid)
RETURNS boolean AS $$
DECLARE
  v_recent_count integer;
BEGIN
  SELECT COUNT(*)
  INTO v_recent_count
  FROM check_ins
  WHERE user_id = p_user_id
    AND goal_id = p_goal_id
    AND created_at > NOW() - INTERVAL '5 minutes';
  
  RETURN v_recent_count > 1;
END;
$$ LANGUAGE plpgsql STABLE;

CREATE OR REPLACE FUNCTION award_xp(
  p_user_id uuid,
  p_pack_id uuid,
  p_amount integer,
  p_reason text DEFAULT 'check_in'
)
RETURNS TABLE(new_user_xp integer, new_pack_xp integer) AS $$
BEGIN
  UPDATE users
  SET xp = xp + p_amount, updated_at = NOW()
  WHERE id = p_user_id;
  
  UPDATE packs
  SET xp = xp + p_amount, updated_at = NOW()
  WHERE id = p_pack_id;
  
  RETURN QUERY
  SELECT u.xp, p.xp
  FROM users u, packs p
  WHERE u.id = p_user_id AND p.id = p_pack_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_feed_for_user(
  p_user_id uuid,
  p_limit integer DEFAULT 50,
  p_offset integer DEFAULT 0
)
RETURNS TABLE(
  id uuid,
  pack_id uuid,
  user_id uuid,
  event_type text,
  metadata jsonb,
  visibility text,
  created_at timestamp with time zone
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    fe.id,
    fe.pack_id,
    fe.user_id,
    fe.event_type,
    fe.metadata,
    fe.visibility,
    fe.created_at
  FROM feed_events fe
  LEFT JOIN pack_members pm ON fe.pack_id = pm.pack_id AND pm.user_id = p_user_id
  WHERE
    fe.visibility = 'public'
    OR (fe.visibility = 'private' AND (fe.user_id = p_user_id OR pm.role = 'admin'))
    OR (fe.visibility = 'pack' AND pm.pack_id IS NOT NULL)
  ORDER BY fe.created_at DESC
  LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql STABLE;

CREATE OR REPLACE FUNCTION enforce_punishment(
  p_punishment_id uuid,
  p_enforcer_id uuid
)
RETURNS TABLE(success boolean, error_message text) AS $$
DECLARE
  v_punishment punishments%ROWTYPE;
BEGIN
  SELECT * INTO v_punishment
  FROM punishments
  WHERE id = p_punishment_id AND status = 'pending';
  
  IF v_punishment IS NULL THEN
    RETURN QUERY SELECT false, 'Punishment not found or already executed';
    RETURN;
  END IF;
  
  IF v_punishment.type = 'jail' THEN
    INSERT INTO phone_jails (user_id, pack_id, duration_minutes, reason)
    VALUES (v_punishment.user_id, v_punishment.pack_id, v_punishment.amount, 'From fine');
  END IF;
  
  UPDATE punishments
  SET status = 'served', enforced_by = p_enforcer_id, completed_at = NOW()
  WHERE id = p_punishment_id;
  
  RETURN QUERY SELECT true, NULL;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION calculate_streak(uuid, uuid) IS 'Calculate consecutive successful check-ins for a user in a pack';
COMMENT ON FUNCTION calculate_user_level(integer) IS 'Derive user level from XP (linear: 100 XP per level)';
COMMENT ON FUNCTION calculate_pack_level(integer) IS 'Derive pack level from XP (linear: 500 XP per level)';
COMMENT ON FUNCTION calculate_vote_weight(integer) IS 'Calculate vote weight multiplier (0.5x-2.0x) based on reputation XP';
COMMENT ON FUNCTION detect_cheating(uuid, uuid) IS 'Detect duplicate submissions within 5 minutes';
COMMENT ON FUNCTION award_xp(uuid, uuid, integer, text) IS 'Atomically award XP to user and pack with logging';
COMMENT ON FUNCTION get_feed_for_user(uuid, integer, integer) IS 'Get user feed with visibility-based filtering';
COMMENT ON FUNCTION enforce_punishment(uuid, uuid) IS 'Execute punishment (fine or jail) and mark as served'; 
