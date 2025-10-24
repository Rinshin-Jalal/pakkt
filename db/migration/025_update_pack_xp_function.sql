-- Migration 025: Create function to update pack XP (bypasses RLS)
-- Allows the application to update pack stats after check-ins

CREATE OR REPLACE FUNCTION update_pack_xp_and_level(
  p_pack_id uuid,
  p_xp integer,
  p_level integer
)
RETURNS void
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE packs
  SET
    xp = p_xp,
    level = p_level,
    updated_at = now()
  WHERE id = p_pack_id;
END;
$$;
