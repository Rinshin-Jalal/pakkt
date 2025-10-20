-- Enum types
do $$ begin
  create type pack_role as enum ('owner','admin','member');
exception when duplicate_object then null; end $$;

do $$ begin
  create type fine_status as enum ('open','closed','resolved');
exception when duplicate_object then null; end $$;

do $$ begin
  create type payment_status as enum ('pending','paid','failed');
exception when duplicate_object then null; end $$;

do $$ begin
  create type subject_type as enum ('check_in','comment','fine');
exception when duplicate_object then null; end $$;

do $$ begin
  create type event_type as enum ('check_in_success','check_in_missed','fine_created','fine_voted','fine_enforced','level_up','pack_milestone');
exception when duplicate_object then null; end $$;

do $$ begin
  create type feed_visibility as enum ('private','pack','public');
exception when duplicate_object then null; end $$;

do $$ begin
  create type reputation_action as enum ('vote_yes','vote_no','vote_flagged','cheating_detected');
exception when duplicate_object then null; end $$;


