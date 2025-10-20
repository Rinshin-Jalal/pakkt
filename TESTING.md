# Pakkt Database Testing Guide

## Overview
This document covers comprehensive testing of the Supabase schema, including CRUD operations, RLS policies, XP system, democratic punishment, feed events, reputation tracking, and performance.

## Prerequisites
- Supabase project set up with migrations applied
- `supabase` CLI installed (`brew install supabase` or `npm i -g supabase`)
- Test users created in Supabase Auth
- Service role key available for admin tests

## Setup Test Users

### Create via Supabase Console
1. Go to Supabase Dashboard → Auth → Users
2. Create 3-4 test users:
   - `alice@test.com` (pack owner)
   - `bob@test.com` (pack member)
   - `charlie@test.com` (pack member)
   - `dave@test.com` (non-member)

### Get UUIDs
After creating users, note their UUIDs from the Auth table. Replace placeholders in test scripts.

## Test Categories

### 1. CRUD Operations

#### Users
```sql
-- CREATE: insert via auth trigger
SELECT * FROM public.users WHERE id = '<user-uuid>';

-- READ: fetch user XP
SELECT id, username, user_xp, total_check_ins FROM public.users WHERE id = '<alice-uuid>';

-- UPDATE: modify profile (as self)
UPDATE public.users SET full_name = 'Alice Smith' WHERE id = '<alice-uuid>';

-- DELETE: auth cascade removes user
DELETE FROM auth.users WHERE id = '<alice-uuid>';  -- service role only
```

#### Packs
```sql
-- CREATE: new pack (as authenticated)
INSERT INTO public.packs(name, description, timezone, created_by)
VALUES('Morning Crew', 'Early risers', 'America/New_York', '<alice-uuid>')
RETURNING id;

-- READ: list member packs (auto-filtered by RLS)
SELECT id, name, pack_xp FROM public.packs WHERE id = '<pack-id>';

-- UPDATE: modify pack (owner/admin only)
UPDATE public.packs SET description = 'Updated desc' WHERE id = '<pack-id>';

-- DELETE: remove pack (owner only, cascades members/goals/etc)
DELETE FROM public.packs WHERE id = '<pack-id>';
```

#### Pack Members
```sql
-- CREATE: join pack
INSERT INTO public.pack_members(pack_id, user_id, role)
VALUES('<pack-id>', '<bob-uuid>', 'member')
RETURNING id;

-- READ: list pack members
SELECT user_id, role, current_streak FROM public.pack_members WHERE pack_id = '<pack-id>';

-- UPDATE: promote member (admin only)
UPDATE public.pack_members SET role = 'admin' WHERE pack_id = '<pack-id>' AND user_id = '<bob-uuid>';

-- DELETE: remove member (admin/self)
DELETE FROM public.pack_members WHERE pack_id = '<pack-id>' AND user_id = '<bob-uuid>';
```

#### Goals
```sql
-- CREATE: add goal to pack (admin only)
INSERT INTO public.goals(pack_id, title, description, frequency, window_start, window_end, fine_amount_cents, created_by)
VALUES('<pack-id>', 'Morning Run', '5km before 8am', 'daily', '06:00'::time, '08:00'::time, 500, '<alice-uuid>')
RETURNING id;

-- READ: list pack goals
SELECT id, title, fine_amount_cents FROM public.goals WHERE pack_id = '<pack-id>';

-- UPDATE: modify goal
UPDATE public.goals SET fine_amount_cents = 1000 WHERE id = '<goal-id>';

-- DELETE: remove goal
DELETE FROM public.goals WHERE id = '<goal-id>';
```

#### Check-Ins
```sql
-- CREATE: member checks in (self only, triggers XP/streak/feed)
INSERT INTO public.check_ins(pack_id, goal_id, user_id, note, at)
VALUES('<pack-id>', '<goal-id>', '<bob-uuid>', 'Morning run done!', now())
RETURNING id, streak_after;

-- READ: list check-ins
SELECT user_id, streak_after, created_at FROM public.check_ins WHERE pack_id = '<pack-id>' ORDER BY created_at DESC;

-- UPDATE: edit check-in note (self or admin)
UPDATE public.check_ins SET note = 'Updated note' WHERE id = '<check-in-id>';

-- DELETE: remove check-in
DELETE FROM public.check_ins WHERE id = '<check-in-id>';
```

### 2. XP & Reputation System

#### Check XP Gains
```sql
-- Insert check-in and verify XP increases
INSERT INTO public.check_ins(pack_id, goal_id, user_id, at)
VALUES('<pack-id>', '<goal-id>', '<bob-uuid>', now());

-- Verify user XP increased (+10 base, +5 if streak > 1)
SELECT user_xp FROM public.users WHERE id = '<bob-uuid>';

-- Check feed event created
SELECT event_type, xp_change, data FROM public.feed_events 
WHERE pack_id = '<pack-id>' AND user_id = '<bob-uuid>' ORDER BY created_at DESC LIMIT 1;
```

#### Vote Weight Calculation
```sql
-- Check vote weight based on XP (0.5-2.0 range)
SELECT public.calculate_vote_weight('<voter-uuid>', '<pack-id>') AS weight;

-- Manually set XP for testing
UPDATE public.users SET user_xp = 500 WHERE id = '<bob-uuid>';
SELECT public.calculate_vote_weight('<bob-uuid>', '<pack-id>') AS weight;
```

#### Reputation Log
```sql
-- View reputation history for user in pack
SELECT action, xp_delta, reason, created_at FROM public.reputation_log
WHERE pack_id = '<pack-id>' AND user_id = '<bob-uuid>'
ORDER BY created_at DESC;

-- Check if vote was logged
SELECT action, related_vote_id FROM public.reputation_log
WHERE action = 'vote_yes' AND pack_id = '<pack-id>';
```

### 3. Democratic Punishment (Fine Voting)

#### Create Fine
```sql
-- Create a fine (admin/owner can do, or auto-generate on missed check-in)
INSERT INTO public.fines(pack_id, goal_id, user_id, amount_cents, reason, created_by, required_votes)
VALUES('<pack-id>', '<goal-id>', '<bob-uuid>', 500, 'Missed check-in', '<alice-uuid>', 2)
RETURNING id;
```

#### Weighted Voting
```sql
-- Alice votes YES with her weight
INSERT INTO public.fine_votes(fine_id, voter_id, decision)
VALUES('<fine-id>', '<alice-uuid>', true);
-- Trigger auto-sets vote_weight from XP

-- Check vote weight was set
SELECT voter_id, vote_weight, decision FROM public.fine_votes WHERE fine_id = '<fine-id>';

-- Bob votes NO
INSERT INTO public.fine_votes(fine_id, voter_id, decision)
VALUES('<fine-id>', '<bob-uuid>', false);

-- Check if fine passed (should recompute after each vote)
SELECT passed, payment_status FROM public.fines WHERE id = '<fine-id>';
```

#### Test Vote Abuse
```sql
-- Flag a voter as suspicious
PERFORM public.add_reputation_log(
  '<pack-id>', '<bad-voter-uuid>', 
  'vote_flagged'::reputation_action, -20, 
  'Pattern of always voting opposite'
);

-- Check reputation log
SELECT xp_delta, reason FROM public.reputation_log
WHERE user_id = '<bad-voter-uuid>' AND action = 'vote_flagged';
```

### 4. Cheating Detection

#### Auto-Flagging
```sql
-- Insert first check-in
INSERT INTO public.check_ins(pack_id, goal_id, user_id, at)
VALUES('<pack-id>', '<goal-id>', '<bob-uuid>', now());

-- Insert duplicate within 5 mins (trigger detect_cheating)
INSERT INTO public.check_ins(pack_id, goal_id, user_id, at)
VALUES('<pack-id>', '<goal-id>', '<bob-uuid>', now() + interval '2 minutes');

-- Check cheating report created
SELECT report_type, reason, status FROM public.cheating_reports
WHERE user_id = '<bob-uuid>' ORDER BY created_at DESC LIMIT 1;

-- Check reputation impact
SELECT action, xp_delta FROM public.reputation_log
WHERE user_id = '<bob-uuid>' AND action = 'cheating_detected';
```

### 5. Feed Events

#### Visibility Levels
```sql
-- Private feed (only user)
SELECT event_type, visibility FROM public.feed_events
WHERE user_id = '<bob-uuid>' AND visibility = 'private';

-- Pack-scoped feed (only members)
SELECT event_type, visibility FROM public.feed_events
WHERE pack_id = '<pack-id>' AND visibility = 'pack'
ORDER BY created_at DESC LIMIT 10;

-- Public feed
SELECT event_type, user_id FROM public.feed_events
WHERE visibility = 'public' ORDER BY created_at DESC LIMIT 5;
```

#### Feed Event Types
```sql
-- Check-in success
SELECT * FROM public.feed_events WHERE event_type = 'check_in_success' LIMIT 1;

-- Level up
SELECT * FROM public.feed_events WHERE event_type = 'level_up' LIMIT 1;

-- Fine enforced
SELECT * FROM public.feed_events WHERE event_type = 'fine_enforced' LIMIT 1;
```

### 6. RLS Tests

#### Test as Different Roles

**Non-member cannot see pack content:**
```sql
-- Simulate dave (non-member)
SELECT * FROM public.packs WHERE id = '<pack-id>';  
-- Should return 0 rows

SELECT * FROM public.check_ins WHERE pack_id = '<pack-id>';  
-- Should return 0 rows
```

**Member can see only own content:**
```sql
-- Simulate bob (member)
SELECT * FROM public.check_ins WHERE pack_id = '<pack-id>';
-- Should return bob's check-ins + others' (pack-scoped)

SELECT * FROM public.fines WHERE pack_id = '<pack-id>';
-- Should return all fines in pack (members can see votes)
```

**Admin can modify content:**
```sql
-- Simulate alice (admin)
UPDATE public.check_ins SET note = 'Admin edit' WHERE pack_id = '<pack-id>';
-- Should succeed

UPDATE public.pack_members SET role = 'admin' WHERE pack_id = '<pack-id>' AND user_id = '<bob-uuid>';
-- Should succeed
```

### 7. Performance Tests

#### Query Explain Plans
```sql
-- Latest check-ins per pack
EXPLAIN ANALYZE
SELECT user_id, streak_after, created_at FROM public.check_ins
WHERE pack_id = '<pack-id>'
ORDER BY created_at DESC LIMIT 10;

-- Open fines with vote counts
EXPLAIN ANALYZE
SELECT f.id, count(fv.id) as vote_count, sum(fv.vote_weight) as total_weight
FROM public.fines f
LEFT JOIN public.fine_votes fv ON fv.fine_id = f.id
WHERE f.pack_id = '<pack-id>' AND f.status = 'open'
GROUP BY f.id;

-- Feed for user (visibility-scoped)
EXPLAIN ANALYZE
SELECT event_type, xp_change FROM public.feed_events
WHERE pack_id = '<pack-id>' AND (visibility = 'public' OR visibility = 'pack')
ORDER BY created_at DESC LIMIT 20;

-- Reputation history
EXPLAIN ANALYZE
SELECT action, xp_delta FROM public.reputation_log
WHERE pack_id = '<pack-id>' AND user_id = '<bob-uuid>'
ORDER BY created_at DESC;
```

#### Stress Test
```sql
-- Create 100 check-ins for a member in a day
INSERT INTO public.check_ins(pack_id, goal_id, user_id, at)
SELECT '<pack-id>', '<goal-id>', '<bob-uuid>', now() + (interval '1 minute' * i)
FROM generate_series(1, 100) i;

-- Check XP accumulation
SELECT user_xp FROM public.users WHERE id = '<bob-uuid>';

-- Verify no duplicates (unique daily check-in should fail on duplicates)
```

### 8. Realtime Subscriptions

#### Subscribe to Pack Activity
```typescript
// Example using supabase-js
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(URL, ANON_KEY);

// Subscribe to check-ins in pack (real-time)
supabase
  .channel(`pack:${packId}:check_ins`)
  .on('postgres_changes', {
    event: 'INSERT',
    schema: 'public',
    table: 'check_ins',
    filter: `pack_id=eq.${packId}`
  }, (payload) => {
    console.log('New check-in:', payload.new);
  })
  .subscribe();

// Subscribe to fine votes (real-time)
supabase
  .channel(`pack:${packId}:votes`)
  .on('postgres_changes', {
    event: 'INSERT',
    schema: 'public',
    table: 'fine_votes'
  }, (payload) => {
    console.log('New vote:', payload.new);
  })
  .subscribe();

// Subscribe to feed (real-time, scoped by visibility)
supabase
  .channel(`pack:${packId}:feed`)
  .on('postgres_changes', {
    event: 'INSERT',
    schema: 'public',
    table: 'feed_events',
    filter: `pack_id=eq.${packId}`
  }, (payload) => {
    console.log('Feed event:', payload.new);
  })
  .subscribe();
```

## Automated Test Script

```bash
#!/bin/bash
# Run all SQL tests

SUPABASE_URL="<your-url>"
ANON_KEY="<your-anon-key>"
SERVICE_KEY="<your-service-key>"

# Set environment
export SUPABASE_URL ANON_KEY SERVICE_KEY

# Run test migrations
supabase db push

echo "✓ Migrations applied"

# Run CRUD tests
psql "$SUPABASE_URL" -c "$(cat tests/crud.sql)"
echo "✓ CRUD tests passed"

# Run RLS tests
psql "$SUPABASE_URL" -c "$(cat tests/rls.sql)"
echo "✓ RLS tests passed"

# Run XP tests
psql "$SUPABASE_URL" -c "$(cat tests/xp_reputation.sql)"
echo "✓ XP/Reputation tests passed"

echo "All tests passed!"
```

## Troubleshooting

### "relation does not exist" after migrations
- Run `supabase db push` to apply pending migrations
- Check `supabase migration list` to see status

### RLS denying valid queries
- Verify `auth.uid()` matches user UUID in test
- Check policy with `SELECT * FROM pg_policies WHERE tablename = 'check_ins'`

### XP not updating after check-in
- Verify trigger exists: `SELECT * FROM pg_trigger WHERE tgname LIKE 'after_check_in%'`
- Check function: `SELECT proname FROM pg_proc WHERE proname = 'after_check_in'`

### Vote weight always 1.0
- Verify user has XP: `SELECT user_xp FROM public.users WHERE id = '<uuid>'`
- Test weight manually: `SELECT public.calculate_vote_weight('<uuid>', '<pack-id>')`

### Cheating detection not triggering
- Verify function: `SELECT proname FROM pg_proc WHERE proname = 'detect_cheating'`
- Insert exactly within 5 minutes, same goal, same user
- Check `cheating_reports` table populated

## References
- [Supabase RLS Docs](https://supabase.com/docs/guides/auth/row-level-security)
- [Postgres Realtime](https://supabase.com/docs/guides/realtime)
- [Performance Tuning](https://supabase.com/docs/guides/database/production-checklist)
