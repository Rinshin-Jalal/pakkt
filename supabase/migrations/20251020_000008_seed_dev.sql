-- Optional seed data for local development and testing
-- This is a dev fixture only; comment out or delete for production

-- NOTE: In production, auth.users are created via auth system
-- For this seed to work locally, you must manually create test users via Supabase Auth console
-- or use service role + handle_new_auth_user() function

-- Example packs (manually adjust user IDs from your auth.users)
-- INSERT INTO public.packs(id, name, description, timezone, is_open_join, created_by)
-- VALUES 
--   (gen_random_uuid(), 'Morning Runners', 'Early morning run accountability', 'America/New_York', false, '00000000-0000-0000-0000-000000000001'),
--   (gen_random_uuid(), 'Study Squad', 'Daily learning accountability', 'UTC', true, '00000000-0000-0000-0000-000000000002');

-- Example goals
-- INSERT INTO public.goals(id, pack_id, title, description, frequency, window_start, window_end, fine_amount_cents, created_by)
-- SELECT 
--   gen_random_uuid(), p.id, 'Morning Run', '5km run by 8am', 'daily', '06:00', '08:00', 500, p.created_by
-- FROM public.packs p WHERE p.name = 'Morning Runners'
-- LIMIT 1;

-- Example pack members
-- INSERT INTO public.pack_members(id, pack_id, user_id, role)
-- SELECT gen_random_uuid(), p.id, u.id, 'member'
-- FROM public.packs p, public.users u
-- WHERE p.name = 'Study Squad' AND u.user_xp > 0
-- LIMIT 3;

-- Seed guide:
-- 1. Create auth.users in Supabase console (or via auth API)
-- 2. Manually run this seed replacing UUIDs with real user IDs from auth.users
-- 3. Or use service role client + script to populate

-- TRUNCATE for fresh resets (use with caution):
-- TRUNCATE TABLE public.feed_events CASCADE;
-- TRUNCATE TABLE public.reputation_log CASCADE;
-- TRUNCATE TABLE public.cheating_reports CASCADE;
-- TRUNCATE TABLE public.fine_votes CASCADE;
-- TRUNCATE TABLE public.fines CASCADE;
-- TRUNCATE TABLE public.reactions CASCADE;
-- TRUNCATE TABLE public.comments CASCADE;
-- TRUNCATE TABLE public.check_ins CASCADE;
-- TRUNCATE TABLE public.phone_jails CASCADE;
-- TRUNCATE TABLE public.goals CASCADE;
-- TRUNCATE TABLE public.pack_members CASCADE;
-- TRUNCATE TABLE public.packs CASCADE;
-- TRUNCATE TABLE public.notifications CASCADE;
-- TRUNCATE TABLE public.users CASCADE;

-- See TESTING.md for automated test scripts
