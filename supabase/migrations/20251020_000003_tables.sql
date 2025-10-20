-- Tables and foreign keys with cascades

-- public.users (profile)
create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  full_name text,
  avatar_url text,
  subscription_plan text,
  subscription_status text,
  renewal_at timestamptz,
  total_check_ins int not null default 0,
  total_fines int not null default 0,
  total_fines_paid_cents int not null default 0,
  user_xp int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create unique index if not exists users_username_lower_idx on public.users (lower(username));

-- packs
create table if not exists public.packs (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  is_open_join boolean not null default false,
  timezone text not null default 'UTC',
  check_in_grace_mins int not null default 15,
  pool_balance_cents int not null default 0,
  pack_xp int not null default 0,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

-- pack_members
create table if not exists public.pack_members (
  id uuid primary key default gen_random_uuid(),
  pack_id uuid not null references public.packs(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role pack_role not null default 'member',
  current_streak int not null default 0,
  longest_streak int not null default 0,
  total_check_ins int not null default 0,
  total_fines_cents int not null default 0,
  notifications_enabled boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz,
  unique (pack_id, user_id)
);

create index if not exists pack_members_pack_id_idx on public.pack_members(pack_id);
create index if not exists pack_members_user_id_idx on public.pack_members(user_id);

-- goals
create table if not exists public.goals (
  id uuid primary key default gen_random_uuid(),
  pack_id uuid not null references public.packs(id) on delete cascade,
  title text not null,
  description text,
  frequency text not null,
  window_start time,
  window_end time,
  days_of_week int[],
  fine_amount_cents int,
  auto_fine boolean not null default false,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create index if not exists goals_pack_id_idx on public.goals(pack_id);
create index if not exists goals_created_by_idx on public.goals(created_by);

-- check_ins
create table if not exists public.check_ins (
  id uuid primary key default gen_random_uuid(),
  pack_id uuid not null references public.packs(id) on delete cascade,
  goal_id uuid not null references public.goals(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  note text,
  photo_url text,
  at timestamptz not null default now(),
  streak_after int,
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create index if not exists check_ins_pack_at_idx on public.check_ins(pack_id, at desc);
create index if not exists check_ins_user_at_idx on public.check_ins(user_id, at desc);
create index if not exists check_ins_goal_at_idx on public.check_ins(goal_id, at desc);

-- fines
create table if not exists public.fines (
  id uuid primary key default gen_random_uuid(),
  pack_id uuid not null references public.packs(id) on delete cascade,
  goal_id uuid references public.goals(id) on delete set null,
  user_id uuid not null references auth.users(id) on delete cascade,
  amount_cents int not null check (amount_cents >= 0),
  reason text,
  status fine_status not null default 'open',
  payment_status payment_status not null default 'pending',
  required_votes int not null default 0,
  passed boolean not null default false,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create index if not exists fines_pack_created_idx on public.fines(pack_id, created_at desc);
create index if not exists fines_user_idx on public.fines(user_id);
create index if not exists fines_status_idx on public.fines(status);
create index if not exists fines_payment_status_idx on public.fines(payment_status);

-- fine_votes
create table if not exists public.fine_votes (
  id uuid primary key default gen_random_uuid(),
  fine_id uuid not null references public.fines(id) on delete cascade,
  voter_id uuid not null references auth.users(id) on delete cascade,
  decision boolean not null,
  vote_weight numeric(5,2) not null default 1.0,
  voted_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz,
  unique (fine_id, voter_id)
);

create index if not exists fine_votes_fine_id_idx on public.fine_votes(fine_id);

-- phone_jails
create table if not exists public.phone_jails (
  id uuid primary key default gen_random_uuid(),
  pack_id uuid not null references public.packs(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  started_at timestamptz not null default now(),
  ended_at timestamptz,
  duration_seconds int generated always as (coalesce(extract(epoch from (ended_at - started_at))::int, 0)) stored,
  status text not null default 'active' check (status in ('active','ended')),
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create index if not exists phone_jails_pack_idx on public.phone_jails(pack_id);
create index if not exists phone_jails_user_started_idx on public.phone_jails(user_id, started_at desc);

-- reactions
create table if not exists public.reactions (
  id uuid primary key default gen_random_uuid(),
  pack_id uuid not null references public.packs(id) on delete cascade,
  subject_type subject_type not null,
  subject_id uuid not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  emoji text not null,
  created_at timestamptz not null default now()
);

create unique index if not exists reactions_unique_idx on public.reactions(subject_type, subject_id, user_id, emoji);
create index if not exists reactions_pack_created_idx on public.reactions(pack_id, created_at desc);
create index if not exists reactions_subject_idx on public.reactions(subject_type, subject_id);

-- comments
create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  pack_id uuid not null references public.packs(id) on delete cascade,
  subject_type subject_type not null,
  subject_id uuid not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  body text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create index if not exists comments_pack_created_idx on public.comments(pack_id, created_at desc);
create index if not exists comments_subject_idx on public.comments(subject_type, subject_id);

-- notifications
create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  body text,
  data jsonb,
  sent_at timestamptz,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

create index if not exists notifications_user_sent_idx on public.notifications(user_id, sent_at desc);
create index if not exists notifications_data_gin on public.notifications using gin (data);

-- feed_events: social activity log
create table if not exists public.feed_events (
  id uuid primary key default gen_random_uuid(),
  pack_id uuid not null references public.packs(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  event_type event_type not null,
  subject_type subject_type,
  subject_id uuid,
  xp_change int default 0,
  visibility feed_visibility not null default 'pack',
  data jsonb,
  created_at timestamptz not null default now()
);

create index if not exists feed_events_pack_created_idx on public.feed_events(pack_id, created_at desc);
create index if not exists feed_events_user_created_idx on public.feed_events(user_id, created_at desc);
create index if not exists feed_events_visibility_idx on public.feed_events(visibility);

-- reputation_log: tracks voting integrity and reputation changes
create table if not exists public.reputation_log (
  id uuid primary key default gen_random_uuid(),
  pack_id uuid not null references public.packs(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  action reputation_action not null,
  related_vote_id uuid,
  related_fine_id uuid references public.fines(id) on delete set null,
  xp_delta int default 0,
  reason text,
  created_at timestamptz not null default now()
);

create index if not exists reputation_log_pack_user_idx on public.reputation_log(pack_id, user_id, created_at desc);
create index if not exists reputation_log_user_created_idx on public.reputation_log(user_id, created_at desc);
create index if not exists reputation_log_action_idx on public.reputation_log(action);

-- cheating_reports: auto-flagged or manual cheating allegations
create table if not exists public.cheating_reports (
  id uuid primary key default gen_random_uuid(),
  pack_id uuid not null references public.packs(id) on delete cascade,
  check_in_id uuid not null references public.check_ins(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  report_type text not null,
  reason text,
  flagged_by uuid references auth.users(id) on delete set null,
  status text not null default 'pending' check (status in ('pending','investigating','confirmed','dismissed')),
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create index if not exists cheating_reports_pack_idx on public.cheating_reports(pack_id, created_at desc);
create index if not exists cheating_reports_user_idx on public.cheating_reports(user_id);
create index if not exists cheating_reports_status_idx on public.cheating_reports(status);


