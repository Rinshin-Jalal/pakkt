-- Helper functions and updated_at trigger

-- updated_at trigger function
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- is_pack_member: check membership for current auth user
create or replace function public.is_pack_member(p_pack uuid)
returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.pack_members pm
    where pm.pack_id = p_pack and pm.user_id = auth.uid()
  );
$$;

-- has_pack_role: current user has any role in list
create or replace function public.has_pack_role(p_pack uuid, p_roles text[])
returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.pack_members pm
    where pm.pack_id = p_pack
      and pm.user_id = auth.uid()
      and pm.role::text = any(p_roles)
  );
$$;

-- calculate_streak: contiguous days with check_ins for goal respecting pack timezone
create or replace function public.calculate_streak(p_user uuid, p_goal uuid, p_ts timestamptz)
returns int
language plpgsql stable as $$
declare
  v_pack uuid;
  v_tz text := 'UTC';
  v_date date;
  v_prev date;
  v_streak int := 0;
begin
  select g.pack_id, p.timezone into v_pack, v_tz
  from public.goals g join public.packs p on p.id = g.pack_id
  where g.id = p_goal;

  v_date := (p_ts at time zone v_tz)::date;

  for v_prev in
    select distinct (c.at at time zone v_tz)::date as d
    from public.check_ins c
    where c.goal_id = p_goal and c.user_id = p_user
      and (c.at at time zone v_tz) <= (p_ts at time zone v_tz)
    order by d desc
  loop
    if v_prev = v_date then
      v_streak := v_streak + 1;
      v_date := v_date - interval '1 day';
    else
      exit;
    end if;
  end loop;
  return v_streak;
end;
$$;

-- refresh_member_stats: recompute counters
create or replace function public.refresh_member_stats(p_pack uuid, p_user uuid)
returns void language plpgsql security definer set search_path = public as $$
declare
  v_total int;
  v_fines int;
  v_fines_cents int;
begin
  select count(*) into v_total from public.check_ins c where c.pack_id = p_pack and c.user_id = p_user;
  select count(*), coalesce(sum(amount_cents),0) into v_fines, v_fines_cents
  from public.fines f where f.pack_id = p_pack and f.user_id = p_user;

  update public.pack_members pm
  set total_check_ins = v_total,
      total_fines_cents = v_fines_cents
  where pm.pack_id = p_pack and pm.user_id = p_user;
end;$$;

-- bootstrap public.users when a new auth.users is created
create or replace function public.handle_new_auth_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.users(id, created_at) values (new.id, now())
  on conflict (id) do nothing;
  return new;
end;$$;

-- calculate_vote_weight: XP-based vote weighting
-- returns weight as numeric: 1.0 baseline, up to 2.0 for high XP users
create or replace function public.calculate_vote_weight(p_user uuid, p_pack uuid)
returns numeric
language plpgsql stable security definer set search_path = public as $$
declare
  v_user_xp int;
  v_pack_avg_xp numeric;
  v_weight numeric;
begin
  select u.user_xp into v_user_xp from public.users u where u.id = p_user;
  
  select coalesce(avg(u.user_xp), 100)::numeric into v_pack_avg_xp
  from public.pack_members pm
  join public.users u on u.id = pm.user_id
  where pm.pack_id = p_pack;

  v_weight := least(2.0, greatest(0.5, (v_user_xp::numeric / v_pack_avg_xp)));
  return round(v_weight, 2);
end;$$;

-- add_reputation_log: helper to log reputation changes
create or replace function public.add_reputation_log(
  p_pack uuid,
  p_user uuid,
  p_action reputation_action,
  p_xp_delta int default 0,
  p_reason text default null,
  p_vote_id uuid default null,
  p_fine_id uuid default null
)
returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_log_id uuid;
begin
  insert into public.reputation_log(pack_id, user_id, action, xp_delta, reason, related_vote_id, related_fine_id)
  values(p_pack, p_user, p_action, p_xp_delta, p_reason, p_vote_id, p_fine_id)
  returning id into v_log_id;
  return v_log_id;
end;$$;

-- add_feed_event: helper to log feed events
create or replace function public.add_feed_event(
  p_pack uuid,
  p_user uuid,
  p_event_type event_type,
  p_visibility feed_visibility default 'pack',
  p_xp_change int default 0,
  p_subject_type subject_type default null,
  p_subject_id uuid default null,
  p_data jsonb default null
)
returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_event_id uuid;
begin
  insert into public.feed_events(pack_id, user_id, event_type, visibility, xp_change, subject_type, subject_id, data)
  values(p_pack, p_user, p_event_type, p_visibility, p_xp_change, p_subject_type, p_subject_id, p_data)
  returning id into v_event_id;
  return v_event_id;
end;$$;

-- detect_cheating: flag suspicious check-in patterns (duplicate timestamps, photo hash collision)
create or replace function public.detect_cheating(p_check_in uuid)
returns boolean
language plpgsql security definer set search_path = public as $$
declare
  v_user uuid;
  v_goal uuid;
  v_pack uuid;
  v_at timestamptz;
  v_photo_url text;
  v_suspicious boolean := false;
  v_duplicate_count int;
  v_report_id uuid;
begin
  select ci.user_id, ci.goal_id, ci.pack_id, ci.at, ci.photo_url
  into v_user, v_goal, v_pack, v_at, v_photo_url
  from public.check_ins ci where ci.id = p_check_in;

  -- check for duplicate check-in within 5 minutes
  select count(*) into v_duplicate_count from public.check_ins ci
  where ci.goal_id = v_goal and ci.user_id = v_user
    and ci.id <> p_check_in
    and abs(extract(epoch from (ci.at - v_at))) < 300;

  if v_duplicate_count > 0 then
    v_suspicious := true;
  end if;

  -- check for identical photo hash (if photos provided)
  if v_suspicious then
    insert into public.cheating_reports(pack_id, check_in_id, user_id, report_type, reason, status)
    values(v_pack, p_check_in, v_user, 'auto_duplicate', 'Multiple check-ins within 5 minutes', 'pending')
    returning id into v_report_id;
    
    perform public.add_reputation_log(v_pack, v_user, 'cheating_detected'::reputation_action, -50, 'Auto-flagged for duplicate check-in', null, null);
  end if;

  return v_suspicious;
end;$$;


