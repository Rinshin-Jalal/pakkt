-- Enable RLS and add policies for private pack model

alter table public.users enable row level security;
alter table public.packs enable row level security;
alter table public.pack_members enable row level security;
alter table public.goals enable row level security;
alter table public.check_ins enable row level security;
alter table public.fines enable row level security;
alter table public.fine_votes enable row level security;
alter table public.phone_jails enable row level security;
alter table public.reactions enable row level security;
alter table public.comments enable row level security;
alter table public.notifications enable row level security;

-- USERS
drop policy if exists users_select on public.users;
create policy users_select on public.users
for select to authenticated
using (true);

drop policy if exists users_update_self on public.users;
create policy users_update_self on public.users
for update to authenticated
using (id = auth.uid());

-- Packs
drop policy if exists packs_select on public.packs;
create policy packs_select on public.packs
for select to authenticated
using (public.is_pack_member(id));

drop policy if exists packs_insert on public.packs;
create policy packs_insert on public.packs
for insert to authenticated
with check (true);

drop policy if exists packs_update on public.packs;
create policy packs_update on public.packs
for update to authenticated
using (public.has_pack_role(id, array['owner','admin']))
with check (public.has_pack_role(id, array['owner','admin']));

drop policy if exists packs_delete on public.packs;
create policy packs_delete on public.packs
for delete to authenticated
using (public.has_pack_role(id, array['owner']));

-- Pack Members
drop policy if exists pack_members_select on public.pack_members;
create policy pack_members_select on public.pack_members
for select to authenticated
using (public.is_pack_member(pack_id));

drop policy if exists pack_members_insert on public.pack_members;
create policy pack_members_insert on public.pack_members
for insert to authenticated
with check (
  public.has_pack_role(pack_id, array['owner','admin'])
  or (user_id = auth.uid() and (select is_open_join from public.packs p where p.id = pack_id))
);

drop policy if exists pack_members_update on public.pack_members;
create policy pack_members_update on public.pack_members
for update to authenticated
using (
  public.has_pack_role(pack_id, array['owner','admin'])
  or (user_id = auth.uid())
)
with check (
  public.has_pack_role(pack_id, array['owner','admin'])
  or (user_id = auth.uid())
);

drop policy if exists pack_members_delete on public.pack_members;
create policy pack_members_delete on public.pack_members
for delete to authenticated
using (public.has_pack_role(pack_id, array['owner','admin']) or user_id = auth.uid());

-- Goals
drop policy if exists goals_select on public.goals;
create policy goals_select on public.goals
for select to authenticated
using (public.is_pack_member(pack_id));

drop policy if exists goals_insert on public.goals;
create policy goals_insert on public.goals
for insert to authenticated
with check (public.has_pack_role(pack_id, array['owner','admin']));

drop policy if exists goals_update on public.goals;
create policy goals_update on public.goals
for update to authenticated
using (public.has_pack_role(pack_id, array['owner','admin']))
with check (public.has_pack_role(pack_id, array['owner','admin']));

drop policy if exists goals_delete on public.goals;
create policy goals_delete on public.goals
for delete to authenticated
using (public.has_pack_role(pack_id, array['owner','admin']));

-- Check Ins
drop policy if exists check_ins_select on public.check_ins;
create policy check_ins_select on public.check_ins
for select to authenticated
using (public.is_pack_member(pack_id));

drop policy if exists check_ins_insert on public.check_ins;
create policy check_ins_insert on public.check_ins
for insert to authenticated
with check (public.is_pack_member(pack_id) and user_id = auth.uid());

drop policy if exists check_ins_update on public.check_ins;
create policy check_ins_update on public.check_ins
for update to authenticated
using (public.has_pack_role(pack_id, array['owner','admin']) or user_id = auth.uid())
with check (public.has_pack_role(pack_id, array['owner','admin']) or user_id = auth.uid());

drop policy if exists check_ins_delete on public.check_ins;
create policy check_ins_delete on public.check_ins
for delete to authenticated
using (public.has_pack_role(pack_id, array['owner','admin']) or user_id = auth.uid());

-- Fines
drop policy if exists fines_select on public.fines;
create policy fines_select on public.fines
for select to authenticated
using (public.is_pack_member(pack_id));

drop policy if exists fines_insert on public.fines;
create policy fines_insert on public.fines
for insert to authenticated
with check (public.has_pack_role(pack_id, array['owner','admin']) or user_id = auth.uid());

drop policy if exists fines_update on public.fines;
create policy fines_update on public.fines
for update to authenticated
using (public.has_pack_role(pack_id, array['owner','admin']) or created_by = auth.uid())
with check (public.has_pack_role(pack_id, array['owner','admin']) or created_by = auth.uid());

drop policy if exists fines_delete on public.fines;
create policy fines_delete on public.fines
for delete to authenticated
using (public.has_pack_role(pack_id, array['owner','admin']));

-- Fine Votes
drop policy if exists fine_votes_select on public.fine_votes;
create policy fine_votes_select on public.fine_votes
for select to authenticated
using (exists (
  select 1 from public.fines f where f.id = fine_id and public.is_pack_member(f.pack_id)
));

drop policy if exists fine_votes_insert on public.fine_votes;
create policy fine_votes_insert on public.fine_votes
for insert to authenticated
with check (
  voter_id = auth.uid() and exists (
    select 1 from public.fines f where f.id = fine_id and public.is_pack_member(f.pack_id)
  )
);

-- Phone Jails
drop policy if exists phone_jails_select on public.phone_jails;
create policy phone_jails_select on public.phone_jails
for select to authenticated
using (public.is_pack_member(pack_id));

drop policy if exists phone_jails_insert on public.phone_jails;
create policy phone_jails_insert on public.phone_jails
for insert to authenticated
with check (public.is_pack_member(pack_id) and user_id = auth.uid());

drop policy if exists phone_jails_update on public.phone_jails;
create policy phone_jails_update on public.phone_jails
for update to authenticated
using (public.has_pack_role(pack_id, array['owner','admin']) or user_id = auth.uid())
with check (public.has_pack_role(pack_id, array['owner','admin']) or user_id = auth.uid());

-- Reactions
drop policy if exists reactions_select on public.reactions;
create policy reactions_select on public.reactions
for select to authenticated
using (public.is_pack_member(pack_id));

drop policy if exists reactions_insert on public.reactions;
create policy reactions_insert on public.reactions
for insert to authenticated
with check (public.is_pack_member(pack_id) and user_id = auth.uid());

drop policy if exists reactions_delete on public.reactions;
create policy reactions_delete on public.reactions
for delete to authenticated
using (public.has_pack_role(pack_id, array['owner','admin']) or user_id = auth.uid());

-- Comments
drop policy if exists comments_select on public.comments;
create policy comments_select on public.comments
for select to authenticated
using (public.is_pack_member(pack_id));

drop policy if exists comments_insert on public.comments;
create policy comments_insert on public.comments
for insert to authenticated
with check (public.is_pack_member(pack_id) and user_id = auth.uid());

drop policy if exists comments_update on public.comments;
create policy comments_update on public.comments
for update to authenticated
using (public.has_pack_role(pack_id, array['owner','admin']) or user_id = auth.uid())
with check (public.has_pack_role(pack_id, array['owner','admin']) or user_id = auth.uid());

drop policy if exists comments_delete on public.comments;
create policy comments_delete on public.comments
for delete to authenticated
using (public.has_pack_role(pack_id, array['owner','admin']) or user_id = auth.uid());

-- Notifications
drop policy if exists notifications_select on public.notifications;
create policy notifications_select on public.notifications
for select to authenticated
using (user_id = auth.uid());

drop policy if exists notifications_update on public.notifications;
create policy notifications_update on public.notifications
for update to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

-- Feed Events
alter table public.feed_events enable row level security;

drop policy if exists feed_events_select on public.feed_events;
create policy feed_events_select on public.feed_events
for select to authenticated
using (
  visibility = 'public'
  or (visibility = 'pack' and public.is_pack_member(pack_id))
  or (visibility = 'private' and user_id = auth.uid())
);

drop policy if exists feed_events_insert on public.feed_events;
create policy feed_events_insert on public.feed_events
for insert to authenticated
with check (false);  -- only service role can create

-- Reputation Log
alter table public.reputation_log enable row level security;

drop policy if exists reputation_log_select on public.reputation_log;
create policy reputation_log_select on public.reputation_log
for select to authenticated
using (public.is_pack_member(pack_id));

drop policy if exists reputation_log_insert on public.reputation_log;
create policy reputation_log_insert on public.reputation_log
for insert to authenticated
with check (false);  -- only service role can create

-- Cheating Reports
alter table public.cheating_reports enable row level security;

drop policy if exists cheating_reports_select on public.cheating_reports;
create policy cheating_reports_select on public.cheating_reports
for select to authenticated
using (
  public.has_pack_role(pack_id, array['owner','admin'])
  or user_id = auth.uid()
);

drop policy if exists cheating_reports_insert on public.cheating_reports;
create policy cheating_reports_insert on public.cheating_reports
for insert to authenticated
with check (public.has_pack_role(pack_id, array['owner','admin']) or (flagged_by = auth.uid() and user_id <> auth.uid()));

drop policy if exists cheating_reports_update on public.cheating_reports;
create policy cheating_reports_update on public.cheating_reports
for update to authenticated
using (public.has_pack_role(pack_id, array['owner','admin']))
with check (public.has_pack_role(pack_id, array['owner','admin']));


