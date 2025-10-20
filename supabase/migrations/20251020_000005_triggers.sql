-- Triggers: updated_at, streak, votes, payments, auth user bootstrap

-- apply updated_at to tables that have it
do $$ begin
  perform 1 from pg_trigger where tgname = 'set_updated_at_users';
  if not found then
    create trigger set_updated_at_users before update on public.users
    for each row execute function public.set_updated_at();
  end if;
end $$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'set_updated_at_packs';
  if not found then
    create trigger set_updated_at_packs before update on public.packs
    for each row execute function public.set_updated_at();
  end if;
end $$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'set_updated_at_pack_members';
  if not found then
    create trigger set_updated_at_pack_members before update on public.pack_members
    for each row execute function public.set_updated_at();
  end if;
end $$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'set_updated_at_goals';
  if not found then
    create trigger set_updated_at_goals before update on public.goals
    for each row execute function public.set_updated_at();
  end if;
end $$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'set_updated_at_check_ins';
  if not found then
    create trigger set_updated_at_check_ins before update on public.check_ins
    for each row execute function public.set_updated_at();
  end if;
end $$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'set_updated_at_fines';
  if not found then
    create trigger set_updated_at_fines before update on public.fines
    for each row execute function public.set_updated_at();
  end if;
end $$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'set_updated_at_fine_votes';
  if not found then
    create trigger set_updated_at_fine_votes before update on public.fine_votes
    for each row execute function public.set_updated_at();
  end if;
end $$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'set_updated_at_phone_jails';
  if not found then
    create trigger set_updated_at_phone_jails before update on public.phone_jails
    for each row execute function public.set_updated_at();
  end if;
end $$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'set_updated_at_comments';
  if not found then
    create trigger set_updated_at_comments before update on public.comments
    for each row execute function public.set_updated_at();
  end if;
end $$;

-- streak/stat updates after check_in
create or replace function public.after_check_in()
returns trigger language plpgsql security definer set search_path = public as $$
declare
  v_streak int;
  v_xp_gained int := 10;
  v_bonus int := 0;
begin
  v_streak := public.calculate_streak(new.user_id, new.goal_id, new.at);
  update public.check_ins set streak_after = v_streak where id = new.id;

  -- update member stats
  update public.pack_members pm
  set total_check_ins = pm.total_check_ins + 1,
      current_streak = case when v_streak > pm.current_streak then v_streak else pm.current_streak end,
      longest_streak = case when v_streak > pm.longest_streak then v_streak else pm.longest_streak end
  where pm.pack_id = new.pack_id and pm.user_id = new.user_id;

  -- XP gains: +10 base, +5 for streak continuation
  if v_streak > 1 then
    v_bonus := 5;
  end if;
  
  update public.users set user_xp = user_xp + v_xp_gained + v_bonus where id = new.user_id;
  update public.packs set pack_xp = pack_xp + (v_xp_gained + v_bonus) where id = new.pack_id;

  -- create feed event
  perform public.add_feed_event(
    new.pack_id, new.user_id, 'check_in_success'::event_type, 'pack'::feed_visibility,
    v_xp_gained + v_bonus, 'check_in'::subject_type, new.id,
    jsonb_build_object('streak', v_streak)
  );

  -- detect cheating
  perform public.detect_cheating(new.id);

  return new;
end;$$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'after_check_in_trigger';
  if not found then
    create trigger after_check_in_trigger after insert on public.check_ins
    for each row execute function public.after_check_in();
  end if;
end $$;

-- fine_votes: recompute pass status with weighted votes
create or replace function public.recompute_fine_votes()
returns trigger language plpgsql security definer set search_path = public as $$
declare
  v_total_weight numeric;
  v_yes_weight numeric;
  v_required int;
  v_pack uuid;
  v_fine_id uuid;
  v_passed boolean;
begin
  v_fine_id := coalesce(new.fine_id, old.fine_id);
  
  select f.required_votes, f.pack_id into v_required, v_pack from public.fines f where f.id = v_fine_id;
  
  select coalesce(sum(vote_weight), 0), coalesce(sum(case when decision then vote_weight else 0 end), 0)
    into v_total_weight, v_yes_weight
  from public.fine_votes
  where fine_id = v_fine_id;

  -- pass if votes >= required AND majority (yes > 50% of total weight)
  v_passed := (v_total_weight >= v_required and v_yes_weight * 2 > v_total_weight);

  update public.fines
  set passed = v_passed
  where id = v_fine_id;

  -- log vote in reputation for tracking
  if new.id is not null then
    perform public.add_reputation_log(
      v_pack, new.voter_id,
      case when new.decision then 'vote_yes'::reputation_action else 'vote_no'::reputation_action end,
      0, 'Vote on fine', new.id, v_fine_id
    );
  end if;

  return coalesce(new, old);
end;$$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'recompute_fine_votes_trigger_ins';
  if not found then
    create trigger recompute_fine_votes_trigger_ins after insert on public.fine_votes
    for each row execute function public.recompute_fine_votes();
  end if;
end $$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'recompute_fine_votes_trigger_upd';
  if not found then
    create trigger recompute_fine_votes_trigger_upd after update on public.fine_votes
    for each row execute function public.recompute_fine_votes();
  end if;
end $$;

-- payments: when a fine is marked paid
create or replace function public.after_fine_payment()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if new.payment_status = 'paid' and coalesce(old.payment_status,'pending') <> 'paid' then
    update public.packs set pool_balance_cents = pool_balance_cents + new.amount_cents where id = new.pack_id;
    update public.users set total_fines_paid_cents = total_fines_paid_cents + new.amount_cents where id = new.user_id;
    
    perform public.add_feed_event(
      new.pack_id, new.user_id, 'fine_enforced'::event_type, 'pack'::feed_visibility,
      -20, 'fine'::subject_type, new.id
    );
  end if;
  return new;
end;$$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'after_fine_payment_trigger';
  if not found then
    create trigger after_fine_payment_trigger after update of payment_status on public.fines
    for each row execute function public.after_fine_payment();
  end if;
end $$;

-- bootstrap public.users when a new auth.users is created
create or replace function public.on_auth_user_created()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  perform public.handle_new_auth_user();
  return new;
end;$$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'on_auth_user_created_trigger';
  if not found then
    create trigger on_auth_user_created_trigger after insert on auth.users
    for each row execute function public.on_auth_user_created();
  end if;
end $$;

-- set vote_weight on fine_votes insert from user XP
create or replace function public.set_vote_weight()
returns trigger language plpgsql security definer set search_path = public as $$
declare
  v_pack uuid;
  v_weight numeric;
begin
  select f.pack_id into v_pack from public.fines f where f.id = new.fine_id;
  v_weight := public.calculate_vote_weight(new.voter_id, v_pack);
  new.vote_weight := v_weight;
  return new;
end;$$;

do $$ begin
  perform 1 from pg_trigger where tgname = 'set_vote_weight_trigger';
  if not found then
    create trigger set_vote_weight_trigger before insert on public.fine_votes
    for each row execute function public.set_vote_weight();
  end if;
end $$;


