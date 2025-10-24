-- Migration 024: Allow pack members to see all members in their packs
-- Currently users can only see their own membership, blocking pack stats/member lists

-- Drop the overly restrictive SELECT policies
DROP POLICY IF EXISTS "Users can read own memberships" ON pack_members;
DROP POLICY IF EXISTS "pack_members_select_own" ON pack_members;

-- Allow users to see their own memberships
CREATE POLICY "pack_members_select_own" ON pack_members
  FOR SELECT
  USING (auth.uid() = user_id);

-- Allow users to see all members in packs they belong to
-- Using SECURITY DEFINER function to avoid RLS recursion
CREATE OR REPLACE FUNCTION user_is_pack_member(p_pack_id uuid)
RETURNS boolean
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM pack_members
    WHERE pack_id = p_pack_id
      AND user_id = auth.uid()
      AND is_active = true
  );
END;
$$;

CREATE POLICY "pack_members_can_see_pack_members" ON pack_members
  FOR SELECT
  USING (user_is_pack_member(pack_id));
