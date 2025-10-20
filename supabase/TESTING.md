# Pakkt Database Testing Guide

**Version:** 1.0 | **Last Updated:** January 2025

Comprehensive test suite for the Pakkt database schema, including CRUD operations, RLS policies, and performance benchmarks.

---

## Test Setup

### Prerequisites
```bash
# Connect to your Supabase instance
psql postgresql://postgres:password@localhost:5432/postgres
# OR use Supabase SQL editor at https://app.supabase.com
```

### Test Helpers
```sql
-- Helper: Generate test user ID
SELECT gen_random_uuid() as test_user_id;

-- Helper: Set authenticated context (for RLS testing)
SET request.jwt.claims = '{"sub":"<user_uuid>"}';

-- Helper: Reset test data
TRUNCATE users, packs, pack_members, goals, check_ins, fines, fine_votes, 
          punishments, transactions, powerups, user_powerups, phone_jails,
          reactions, comments, feed_events, challenge_rooms, challenge_participants,
          notifications, reputation_log CASCADE;
```

---

## CRUD Tests

### 1. Users Table

#### CREATE User
```sql
INSERT INTO users (username, email, password_hash, xp, coins)
VALUES (
  'testuser_' || substring(gen_random_uuid()::text, 1, 8),
  'test_' || substring(gen_random_uuid()::text, 1, 8) || '@example.com',
  'hashed_password_' || substring(gen_random_uuid()::text, 1, 8),
  50,
  100
)
RETURNING id, username, email, xp, level, coins;

-- Expected: New user with level=1 (50 XP → Level 1)
```

#### READ User
```sql
SELECT id, username, email, xp, level, coins, streak_count, phone_jail_opt_in
FROM users
WHERE username = 'testuser_abc123'
LIMIT 1;

-- Expected: User record with default values
```

#### UPDATE User (XP)
```sql
UPDATE users
SET xp = xp + 100
WHERE username = 'testuser_abc123'
RETURNING id, xp, level, updated_at;

-- Expected: XP increased, level recalculated (150 XP → Level 2), updated_at changed
```

#### DELETE User
```sql
DELETE FROM users WHERE username = 'testuser_abc123';

-- Expected: Cascades to pack_members, fines, check_ins (if CASCADE setup correctly)
```

---

### 2. Packs Table

#### CREATE Pack
```sql
DO $$ DECLARE test_user_id uuid;
BEGIN
  INSERT INTO users (username, email, password_hash)
  VALUES ('creator_' || substring(gen_random_uuid()::text, 1, 8), 
          'creator@test.com', 'hash')
  RETURNING id INTO test_user_id;
  
  INSERT INTO packs (name, creator_id, goal_type, status)
  VALUES (
    'Test Pack ' || substring(gen_random_uuid()::text, 1, 8),
    test_user_id,
    'gym',
    'active'
  )
  RETURNING id, name, creator_id, xp, level, goal_type;
END $$;

-- Expected: New pack with level=1, status='active'
```

#### READ Pack (with Membership Check)
```sql
SELECT p.id, p.name, p.xp, p.level, pm.role
FROM packs p
LEFT JOIN pack_members pm ON p.id = pm.pack_id
WHERE p.goal_type = 'gym'
LIMIT 5;

-- Expected: Packs with membership info
```

#### UPDATE Pack (XP)
```sql
UPDATE packs
SET xp = xp + 500
WHERE name LIKE 'Test Pack%'
RETURNING id, xp, level;

-- Expected: XP increased, level recalculated (500 XP → Level 2 for packs)
```

---

### 3. Goals Table

#### CREATE Goal
```sql
DO $$ DECLARE
  test_pack_id uuid;
  test_user_id uuid;
BEGIN
  -- Create test user
  INSERT INTO users (username, email, password_hash)
  VALUES ('goalcreator', 'goal@test.com', 'hash')
  RETURNING id INTO test_user_id;
  
  -- Create test pack
  INSERT INTO packs (name, creator_id, goal_type)
  VALUES ('Goal Test Pack', test_user_id, 'fitness')
  RETURNING id INTO test_pack_id;
  
  -- Create goal
  INSERT INTO goals (pack_id, creator_id, title, schedule, fine_amount, jail_duration, proof_required)
  VALUES (
    test_pack_id,
    test_user_id,
    'Morning Gym',
    '{"days":["Mon","Wed","Fri"],"time":"07:00"}',
    500,
    30,
    true
  )
  RETURNING id, title, schedule, fine_amount, jail_duration, proof_required;
END $$;

-- Expected: Goal with JSON schedule stored correctly
```

#### Verify Goal Schedule
```sql
SELECT id, title, schedule->>'time' as time, schedule->'days' as days
FROM goals
WHERE title = 'Morning Gym';

-- Expected: time="07:00", days=["Mon","Wed","Fri"]
```

---

### 4. Check-ins Table

#### CREATE Check-in (Success)
```sql
DO $$ DECLARE
  test_goal_id uuid;
  test_user_id uuid;
  test_pack_id uuid;
BEGIN
  -- Setup (get IDs from existing data)
  SELECT id INTO test_user_id FROM users LIMIT 1;
  SELECT id INTO test_pack_id FROM packs WHERE creator_id = test_user_id LIMIT 1;
  SELECT id INTO test_goal_id FROM goals WHERE pack_id = test_pack_id LIMIT 1;
  
  -- Create successful check-in
  INSERT INTO check_ins (goal_id, user_id, pack_id, status, proof_url)
  VALUES (test_goal_id, test_user_id, test_pack_id, 'success', 'https://example.com/proof.jpg')
  RETURNING id, goal_id, user_id, status, created_at;
END $$;

-- Expected: Check-in created, triggers fire (XP awarded, feed event created)
```

#### Verify Check-in Triggers
```sql
-- Verify XP was awarded
SELECT id, xp FROM users WHERE id = '<test_user_id>';

-- Expected: XP increased by 10-15 (+ streak bonus)

-- Verify feed event created
SELECT id, event_type, metadata FROM feed_events
WHERE event_type = 'checkin_success'
ORDER BY created_at DESC LIMIT 1;

-- Expected: Feed event with metadata containing check_in_id, xp_awarded, streak
```

#### CREATE Check-in (Duplicate - Cheating Detection)
```sql
-- Submit first check-in
INSERT INTO check_ins (goal_id, user_id, pack_id, status)
VALUES ('<goal_id>', '<user_id>', '<pack_id>', 'success');

-- Try to submit another within 5 minutes
INSERT INTO check_ins (goal_id, user_id, pack_id, status)
VALUES ('<goal_id>', '<user_id>', '<pack_id>', 'success');

-- Query to verify cheating detected
SELECT status FROM check_ins
WHERE goal_id = '<goal_id>' AND user_id = '<user_id>'
ORDER BY created_at;

-- Expected: Both marked as 'missed' (cheating detected)
```

---

### 5. Fines & Voting

#### CREATE Fine (from Missed Check-in)
```sql
-- This would normally be triggered, but for testing:
INSERT INTO fines (check_in_id, pack_id, user_id, amount, voting_ends_at)
VALUES (
  '<check_in_id>',
  '<pack_id>',
  '<user_id>',
  500, -- $5.00
  NOW() + INTERVAL '2 hours'
)
RETURNING id, amount, status, voting_ends_at;

-- Expected: Fine created with status='pending'

-- Verify notifications sent to pack members
SELECT id, type, message, related_entity_id FROM notifications
WHERE type = 'vote_request'
ORDER BY created_at DESC LIMIT 5;

-- Expected: Notification for each pack member
```

#### VOTE on Fine
```sql
-- Get a fine ID
SELECT id FROM fines WHERE status = 'pending' LIMIT 1 \into fine_id

-- Vote (member 1 votes YES)
INSERT INTO fine_votes (fine_id, voter_id, vote)
VALUES (fine_id, '<voter_1_id>', true)
RETURNING id, vote, created_at;

-- Vote (member 2 votes NO)
INSERT INTO fine_votes (fine_id, voter_id, vote)
VALUES (fine_id, '<voter_2_id>', false);

-- Query vote count
SELECT vote, COUNT(*) as count
FROM fine_votes
WHERE fine_id = fine_id
GROUP BY vote;

-- Expected: Shows vote distribution
```

#### ENFORCE Fine
```sql
UPDATE fines
SET status = 'enforced'
WHERE id = '<fine_id>'
RETURNING id, status;

-- Verify feed event created
SELECT event_type, metadata FROM feed_events
WHERE event_type = 'fine_voted'
ORDER BY created_at DESC LIMIT 1;

-- Expected: Feed event with fine_id and amount
```

---

## RLS Policy Tests

### Setup: Create Test Users & Packs
```sql
-- Create 2 test users
INSERT INTO users (username, email, password_hash) 
VALUES ('rls_user1', 'rls1@test.com', 'hash')
RETURNING id \into user1_id;

INSERT INTO users (username, email, password_hash)
VALUES ('rls_user2', 'rls2@test.com', 'hash')
RETURNING id \into user2_id;

-- Create pack with user1 as creator
INSERT INTO packs (name, creator_id, goal_type)
VALUES ('RLS Test Pack', user1_id, 'study')
RETURNING id \into pack_id;

-- Add user2 as member
INSERT INTO pack_members (pack_id, user_id, role)
VALUES (pack_id, user2_id, 'member');
```

### Test 1: User Can Read Own Profile
```sql
-- As user1
SET request.jwt.claims = '{"sub":"<user1_id>"}'::jsonb;
SELECT username, email, xp FROM users WHERE id = '<user1_id>';
-- Expected: Returns data

-- Try to read user2's profile
SELECT username, email FROM users WHERE id = '<user2_id>';
-- Expected: No rows returned (blocked by RLS)
```

### Test 2: Pack Members Can Read Pack Data
```sql
-- As user1 (creator)
SET request.jwt.claims = '{"sub":"<user1_id>"}'::jsonb;
SELECT id, name FROM packs WHERE id = '<pack_id>';
-- Expected: Returns pack

-- As user2 (member)
SET request.jwt.claims = '{"sub":"<user2_id>"}'::jsonb;
SELECT id, name FROM packs WHERE id = '<pack_id>';
-- Expected: Returns pack

-- As unknown user
SET request.jwt.claims = '{"sub":"<random_uuid>"}'::jsonb;
SELECT id, name FROM packs WHERE id = '<pack_id>';
-- Expected: No rows returned
```

### Test 3: Feed Event Visibility
```sql
-- Create feed events with different visibility levels
INSERT INTO feed_events (pack_id, user_id, event_type, visibility)
VALUES 
  ('<pack_id>', '<user1_id>', 'level_up', 'private'),
  ('<pack_id>', '<user1_id>', 'level_up', 'pack'),
  ('<pack_id>', '<user1_id>', 'level_up', 'public');

-- As user1 (should see all 3)
SET request.jwt.claims = '{"sub":"<user1_id>"}'::jsonb;
SELECT visibility, COUNT(*) FROM feed_events 
GROUP BY visibility;
-- Expected: private=1, pack=1, public=1

-- As user2 (member, should see pack + public)
SET request.jwt.claims = '{"sub":"<user2_id>"}'::jsonb;
SELECT visibility, COUNT(*) FROM feed_events 
GROUP BY visibility;
-- Expected: pack=1, public=1 (no private)

-- As unknown user (should see public only)
SET request.jwt.claims = '{"sub":"<random_uuid>"}'::jsonb;
SELECT visibility, COUNT(*) FROM feed_events 
GROUP BY visibility;
-- Expected: public=1
```

### Test 4: Users Can Create Own Check-ins
```sql
-- As user2, try to create check-in for self
SET request.jwt.claims = '{"sub":"<user2_id>"}'::jsonb;
INSERT INTO check_ins (goal_id, user_id, pack_id, status)
VALUES ('<goal_id>', '<user2_id>', '<pack_id>', 'success');
-- Expected: Success

-- As user2, try to create check-in for user1
INSERT INTO check_ins (goal_id, user_id, pack_id, status)
VALUES ('<goal_id>', '<user1_id>', '<pack_id>', 'success');
-- Expected: Error (violates RLS policy)
```

### Test 5: Only Admins Can Manage Pack
```sql
-- As member (user2), try to update pack
SET request.jwt.claims = '{"sub":"<user2_id>"}'::jsonb;
UPDATE packs SET goal_type = 'gym' WHERE id = '<pack_id>';
-- Expected: No rows updated (blocked by RLS)

-- Make user2 an admin
UPDATE pack_members SET role = 'admin' 
WHERE user_id = '<user2_id>' AND pack_id = '<pack_id>';

-- Try again
SET request.jwt.claims = '{"sub":"<user2_id>"}'::jsonb;
UPDATE packs SET goal_type = 'gym' WHERE id = '<pack_id>';
-- Expected: 1 row updated (success)
```

---

## Function Tests

### Test calculate_streak()
```sql
-- Create multiple successful check-ins on consecutive days
DO $$ DECLARE test_goal_id uuid; test_user_id uuid; test_pack_id uuid;
BEGIN
  SELECT id INTO test_user_id FROM users LIMIT 1;
  SELECT id INTO test_pack_id FROM packs LIMIT 1;
  SELECT id INTO test_goal_id FROM goals WHERE pack_id = test_pack_id LIMIT 1;
  
  -- Day 1
  INSERT INTO check_ins (goal_id, user_id, pack_id, status, created_at)
  VALUES (test_goal_id, test_user_id, test_pack_id, 'success', NOW() - INTERVAL '2 days');
  
  -- Day 2
  INSERT INTO check_ins (goal_id, user_id, pack_id, status, created_at)
  VALUES (test_goal_id, test_user_id, test_pack_id, 'success', NOW() - INTERVAL '1 day');
  
  -- Day 3 (today)
  INSERT INTO check_ins (goal_id, user_id, pack_id, status, created_at)
  VALUES (test_goal_id, test_user_id, test_pack_id, 'success', NOW());
END $$;

-- Test function
SELECT calculate_streak('<user_id>'::uuid, '<pack_id>'::uuid) as streak;
-- Expected: 3 (or consecutive count)
```

### Test calculate_user_level()
```sql
SELECT 
  calculate_user_level(0) as level_0,     -- Expected: 1
  calculate_user_level(50) as level_50,   -- Expected: 1
  calculate_user_level(100) as level_100, -- Expected: 2
  calculate_user_level(250) as level_250, -- Expected: 3
  calculate_user_level(1000) as level_1k; -- Expected: 11
```

### Test calculate_vote_weight()
```sql
SELECT 
  calculate_vote_weight(-500) as weight_min,  -- Expected: 0.5
  calculate_vote_weight(0) as weight_zero,    -- Expected: 1.0
  calculate_vote_weight(500) as weight_max;   -- Expected: 2.0
```

### Test detect_cheating()
```sql
-- Insert two check-ins within 5 minutes
INSERT INTO check_ins (goal_id, user_id, pack_id, status, created_at)
VALUES ('<goal_id>', '<user_id>', '<pack_id>', 'success', NOW());

INSERT INTO check_ins (goal_id, user_id, pack_id, status, created_at)
VALUES ('<goal_id>', '<user_id>', '<pack_id>', 'success', NOW() + INTERVAL '2 minutes');

-- Test function
SELECT detect_cheating('<user_id>'::uuid, '<goal_id>'::uuid) as is_cheating;
-- Expected: true
```

### Test get_feed_for_user()
```sql
SET request.jwt.claims = '{"sub":"<user_id>"}'::jsonb;

SELECT * FROM get_feed_for_user('<user_id>'::uuid, 50, 0);
-- Expected: Feed events visible to user based on RLS policies
```

---

## Trigger Tests

### Test: Timestamp Auto-update
```sql
-- Insert user
INSERT INTO users (username, email, password_hash)
VALUES ('timestamp_test', 'ts@test.com', 'hash')
RETURNING id, updated_at \into user_id, updated_at_1;

-- Wait 1 second
SELECT pg_sleep(1);

-- Update user
UPDATE users SET xp = 100 WHERE id = user_id
RETURNING updated_at \into updated_at_2;

-- Compare
SELECT updated_at_1 < updated_at_2 as timestamps_differ;
-- Expected: true (updated_at changed)
```

### Test: XP Award Trigger
```sql
-- Record user XP before
SELECT xp INTO xp_before FROM users WHERE id = '<user_id>';

-- Create successful check-in (should trigger award_xp)
INSERT INTO check_ins (goal_id, user_id, pack_id, status)
VALUES ('<goal_id>', '<user_id>', '<pack_id>', 'success');

-- Check user XP after
SELECT xp INTO xp_after FROM users WHERE id = '<user_id>';

-- Should be higher
SELECT xp_after > xp_before as xp_awarded;
-- Expected: true
```

### Test: Level-up Feed Event
```sql
-- Get user's current level
SELECT level INTO old_level FROM users WHERE id = '<user_id>';

-- Award enough XP for level-up
UPDATE users SET xp = 200 WHERE id = '<user_id>';

-- Check for level_up feed event
SELECT COUNT(*) FROM feed_events
WHERE user_id = '<user_id>' AND event_type = 'level_up';
-- Expected: 1+ (level-up event created)
```

---

## Performance Benchmarks

### Query Performance: Feed Fetch
```sql
EXPLAIN ANALYZE
SELECT * FROM feed_events
WHERE pack_id = '<pack_id>'
AND visibility IN ('pack', 'public')
ORDER BY created_at DESC
LIMIT 50;

-- Expected: Index scan on (pack_id, visibility, created_at)
-- Should be <10ms for 10k+ rows
```

### Query Performance: Check-in Search
```sql
EXPLAIN ANALYZE
SELECT * FROM check_ins
WHERE pack_id = '<pack_id>'
AND user_id = '<user_id>'
AND DATE(created_at) = CURRENT_DATE;

-- Expected: Index scan on (pack_id, user_id, created_at)
-- Should be <5ms
```

### Concurrent Vote Writes
```bash
# Use pgbench to simulate 10 concurrent voters

cat > votes.sql << 'EOF'
INSERT INTO fine_votes (fine_id, voter_id, vote)
VALUES ('<fine_id>', '<voter_id_' || random() || '>', random() > 0.5);
EOF

pgbench -c 10 -j 10 -T 10 -f votes.sql -d pakkt
# Expected: ~1000+ TPS without errors
```

---

## Data Integrity Tests

### Verify Cascade Deletes
```sql
-- Create full data chain
INSERT INTO users (...) RETURNING id INTO user_id;
INSERT INTO packs (...) RETURNING id INTO pack_id;
INSERT INTO pack_members (...) RETURNING id INTO pm_id;
INSERT INTO goals (...) RETURNING id INTO goal_id;
INSERT INTO check_ins (...) RETURNING id INTO ci_id;

-- Delete pack
DELETE FROM packs WHERE id = pack_id;

-- Verify cascades
SELECT COUNT(*) FROM pack_members WHERE pack_id = pack_id;   -- Expected: 0
SELECT COUNT(*) FROM goals WHERE pack_id = pack_id;          -- Expected: 0
SELECT COUNT(*) FROM check_ins WHERE pack_id = pack_id;      -- Expected: 0
```

### Verify Foreign Key Constraints
```sql
-- Try to insert check-in with invalid goal_id
INSERT INTO check_ins (goal_id, user_id, pack_id, status)
VALUES (gen_random_uuid(), '<user_id>', '<pack_id>', 'success');
-- Expected: FK constraint error
```

---

## Test Cleanup

```sql
-- Reset all test data
TRUNCATE users, packs, pack_members, goals, check_ins, fines, fine_votes,
          punishments, phone_jails, transactions, powerups, user_powerups,
          reactions, comments, feed_events, challenge_rooms, challenge_participants,
          notifications, reputation_log CASCADE;

-- Reset sequences (if any)
ALTER SEQUENCE IF EXISTS users_id_seq RESTART WITH 1;
```

---

**Last Updated:** January 2025  
**Test Coverage:** Core CRUD, RLS, Functions, Triggers, Performance, Integrity

