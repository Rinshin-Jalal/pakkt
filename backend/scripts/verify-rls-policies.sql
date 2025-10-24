-- Verification Script: Check RLS Policies from Migration 028
-- Run this in Supabase SQL Editor to verify all policies exist

-- ============================================================================
-- 1. CHECK: pack_members UPDATE policy (users can update own XP)
-- ============================================================================
SELECT
  'pack_members UPDATE policy' as check_name,
  EXISTS(
    SELECT 1 FROM pg_policies
    WHERE tablename = 'pack_members'
    AND policyname = 'users_update_own_pack_stats'
    AND cmd = 'UPDATE'
  ) as exists;

-- ============================================================================
-- 2. CHECK: pack_invite_codes table exists
-- ============================================================================
SELECT
  'pack_invite_codes table' as check_name,
  EXISTS(
    SELECT 1 FROM information_schema.tables
    WHERE table_name = 'pack_invite_codes'
  ) as exists;

-- ============================================================================
-- 3. CHECK: pack_invite_codes RLS enabled
-- ============================================================================
SELECT
  'pack_invite_codes RLS enabled' as check_name,
  relrowsecurity as enabled
FROM pg_class
WHERE relname = 'pack_invite_codes';

-- ============================================================================
-- 4. CHECK: pack_invite_codes policies
-- ============================================================================
SELECT
  policyname,
  cmd as operation,
  qual as using_expression,
  with_check as check_expression
FROM pg_policies
WHERE tablename = 'pack_invite_codes'
ORDER BY policyname;

-- ============================================================================
-- 5. CHECK: fines policies (INSERT and UPDATE for pack members)
-- ============================================================================
SELECT
  policyname,
  cmd as operation
FROM pg_policies
WHERE tablename = 'fines'
AND policyname IN ('pack_members_create_fines', 'pack_members_update_fines')
ORDER BY policyname;

-- ============================================================================
-- 6. CHECK: fine_votes unique constraint (prevents race conditions)
-- ============================================================================
SELECT
  'fine_votes unique constraint' as check_name,
  EXISTS(
    SELECT 1 FROM information_schema.table_constraints
    WHERE table_name = 'fine_votes'
    AND constraint_name = 'fine_votes_user_unique'
    AND constraint_type = 'UNIQUE'
  ) as exists;

-- ============================================================================
-- 7. CHECK: use_invite_code function exists
-- ============================================================================
SELECT
  'use_invite_code function' as check_name,
  EXISTS(
    SELECT 1 FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'public'
    AND p.proname = 'use_invite_code'
  ) as exists;

-- ============================================================================
-- 8. SUMMARY: All RLS policies
-- ============================================================================
SELECT
  tablename,
  policyname,
  cmd as operation,
  permissive
FROM pg_policies
WHERE tablename IN (
  'pack_members',
  'pack_invite_codes',
  'fines',
  'fine_votes',
  'goals'
)
ORDER BY tablename, policyname;

-- ============================================================================
-- 9. EXPECTED RESULTS
-- ============================================================================
/*
EXPECTED POLICIES (from migration 028):

pack_members:
  ✓ users_update_own_pack_stats (UPDATE) - NEW

pack_invite_codes:
  ✓ anyone_read_active_codes (SELECT)
  ✓ pack_creators_create_codes (INSERT)
  ✓ pack_creators_update_codes (UPDATE)

fines:
  ✓ pack_members_create_fines (INSERT) - NEW
  ✓ pack_members_update_fines (UPDATE) - NEW
  ✓ Pack members can read fines (SELECT) - EXISTING

fine_votes:
  ✓ Pack members can vote on fines (INSERT) - EXISTING
  ✓ fine_votes_user_unique CONSTRAINT - NEW

goals:
  ✓ goals_select_pack_goals_simple (SELECT) - EXISTING
*/
