-- Additional performance indexes (beyond those created inline)

-- Ensure lower(username) search fast
create index if not exists users_username_unique_lower on public.users (lower(username));

-- Composite indexes already present in tables file; add missing if any
-- Example query helpers
create index if not exists check_ins_pack_user_at_idx on public.check_ins(pack_id, user_id, at desc);
create index if not exists fines_pack_status_idx on public.fines(pack_id, status, created_at desc);
create index if not exists comments_pack_user_created_idx on public.comments(pack_id, user_id, created_at desc);

-- Feed query optimizations
create index if not exists feed_events_pack_visibility_created_idx on public.feed_events(pack_id, visibility, created_at desc);
create index if not exists feed_events_user_visibility_created_idx on public.feed_events(user_id, visibility, created_at desc);

-- Reputation query optimizations
create index if not exists reputation_log_action_created_idx on public.reputation_log(action, created_at desc);

-- Cheating detection optimizations
create index if not exists cheating_reports_check_in_idx on public.cheating_reports(check_in_id);
create index if not exists cheating_reports_status_created_idx on public.cheating_reports(status, created_at desc);


