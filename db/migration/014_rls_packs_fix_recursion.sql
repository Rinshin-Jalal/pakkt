-- Migration 014: Fix recursion on packs policies
-- Goal: Break mutual dependency between packs and pack_members policies
-- by using helper SECURITY DEFINER functions and simplifying pack_members policies.

-- Helper functions (one-way dependency: functions -> pack_members)
-- Note: These functions do NOT reference packs, avoiding cycles.

CREATE OR REPLACE FUNCTION public.is_pack_member(u uuid, pid uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM pack_members pm
    WHERE pm.user_id = u AND pm.pack_id = pid AND pm.is_active = true
  );
$$;

CREATE OR REPLACE FUNCTION public.is_pack_admin(u uuid, pid uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM pack_members pm
    WHERE pm.user_id = u AND pm.pack_id = pid AND pm.role = 'admin' AND pm.is_active = true
  );
$$;

-- Drop all existing packs policies to remove recursive references
DO $$
DECLARE pol RECORD;
BEGIN
  FOR pol IN
    SELECT policyname FROM pg_policies
    WHERE schemaname = 'public' AND tablename = 'packs'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON packs;', pol.policyname);
  END LOOP;
END
$$;

-- Recreate non-recursive packs policies

-- Users can read packs they own or are members of
CREATE POLICY "Users can read visible packs" ON packs FOR SELECT
  USING (
    auth.uid() = creator_id
    OR public.is_pack_member(auth.uid(), id)
  );

-- Pack admins can update packs
CREATE POLICY "Pack admins can update packs" ON packs FOR UPDATE
  USING (public.is_pack_admin(auth.uid(), id));

-- Only creator can delete pack
CREATE POLICY "Only creator can delete pack" ON packs FOR DELETE
  USING (auth.uid() = creator_id);

-- Ensure INSERT policy exists (idempotent)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public' AND tablename = 'packs'
      AND policyname = 'Users can create packs'
  ) THEN
    CREATE POLICY "Users can create packs" ON packs FOR INSERT
      WITH CHECK (auth.uid() = creator_id);
  END IF;
END
$$;

-- Simplify pack_members policies to avoid referencing packs (break cycle)
DO $$
DECLARE pol RECORD;
BEGIN
  FOR pol IN
    SELECT policyname FROM pg_policies
    WHERE schemaname = 'public' AND tablename = 'pack_members'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON pack_members;', pol.policyname);
  END LOOP;
END
$$;

-- Users can read their own pack memberships
CREATE POLICY "Users can read own pack memberships" ON pack_members FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert themselves as members
CREATE POLICY "Users can insert themselves as members" ON pack_members FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own membership record (e.g., leave)
CREATE POLICY "Users can update own pack membership" ON pack_members FOR UPDATE
  USING (auth.uid() = user_id);

-- Users can delete their own membership (leave pack)
CREATE POLICY "Users can delete own pack membership" ON pack_members FOR DELETE
  USING (auth.uid() = user_id);

