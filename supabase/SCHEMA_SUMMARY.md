# Pakkt Database Schema Summary

**Version:** 1.0 | **PostgreSQL:** 15+ | **Created:** January 2025

Complete reference for all 15+ tables, relationships, and data flows in the Pakkt accountability platform.

---

## Table Definitions

### 1. users
Core user accounts with progression tracking.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | Unique user ID |
| username | text | | UNIQUE NOT NULL | Display handle |
| email | text | | UNIQUE NOT NULL | Auth login |
| password_hash | text | | NOT NULL | Bcrypt/Argon2 hash |
| profile_pic | text | NULL | | Avatar URL |
| bio | text | NULL | | User bio |
| xp | integer | 0 | NOT NULL | Total earned XP |
| level | integer | 1 | NOT NULL | Derived from XP |
| coins | integer | 0 | NOT NULL | In-app currency |
| streak_count | integer | 0 | NOT NULL | Consecutive check-ins |
| phone_jail_opt_in | boolean | false | NOT NULL | Screen Time permission |
| created_at | timestamp | NOW() | NOT NULL | Registration date |
| updated_at | timestamp | NOW() | | Auto-updated |
| last_active | timestamp | NOW() | | Session tracking |

**Indexes:** username, email, created_at

---

### 2. packs
Groups of users enforcing collective accountability.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | Unique pack ID |
| name | text | | NOT NULL | Pack name |
| creator_id | uuid | | FK → users.id | Pack owner |
| xp | integer | 0 | NOT NULL | Collective XP |
| level | integer | 1 | NOT NULL | Derived from XP |
| goal_type | text | NULL | | Category (gym, study, etc.) |
| status | text | 'active' | CHECK: active/dissolved | Lifecycle |
| created_at | timestamp | NOW() | NOT NULL | Creation date |
| updated_at | timestamp | | | Auto-updated |
| last_activity | timestamp | NOW() | | Last event |

**Indexes:** creator_id, status, created_at  
**Cascade Deletes:** pack_members, goals, check_ins, fines

---

### 3. pack_members
Join table linking users to packs with roles.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | |
| pack_id | uuid | | FK → packs.id CASCADE | |
| user_id | uuid | | FK → users.id CASCADE | |
| role | text | 'member' | CHECK: member/admin | Permission level |
| join_date | timestamp | NOW() | NOT NULL | Membership start |
| reputation_xp | integer | 0 | NOT NULL | Fair voting score |
| is_active | boolean | true | NOT NULL | Activity status |
| created_at | timestamp | NOW() | | Record creation |
| updated_at | timestamp | | | Auto-updated |
| | | | UNIQUE(pack_id, user_id) | One membership per user |

**Indexes:** pack_id, user_id, role, is_active

---

### 4. goals
Pack commitments with timing and consequences.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | Goal ID |
| pack_id | uuid | | FK → packs.id CASCADE | Associated pack |
| creator_id | uuid | | FK → users.id RESTRICT | Goal author |
| title | text | | NOT NULL | e.g., "Morning Gym" |
| schedule | jsonb | NULL | | `{days:[...], time:"07:00"}` |
| fine_amount | integer | 5 | NOT NULL | Default fine (cents) |
| jail_duration | integer | 30 | NOT NULL | Screen lock (minutes) |
| proof_required | boolean | false | NOT NULL | Photo/video mandatory |
| active | boolean | true | NOT NULL | Enabled/disabled |
| created_at | timestamp | NOW() | NOT NULL | |
| updated_at | timestamp | | | Auto-updated |

**Indexes:** pack_id, creator_id, active, created_at

---

### 5. check_ins
Daily submissions of goal completion.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | Check-in ID |
| goal_id | uuid | | FK → goals.id CASCADE | Goal being checked |
| user_id | uuid | | FK → users.id CASCADE | Submitter |
| pack_id | uuid | | FK → packs.id CASCADE | Associated pack |
| status | text | 'pending_vote' | CHECK: success/missed/pending | State |
| proof_url | text | NULL | | Media URL |
| created_at | timestamp | NOW() | NOT NULL | Submission time |
| verified_at | timestamp | NULL | | Verification time |
| xp_awarded | integer | 0 | | XP granted on verification |
| updated_at | timestamp | | | Auto-updated |

**Indexes:** goal_id, user_id, pack_id, status, created_at, (pack_id, user_id, created_at)  
**States:** success (verified) → packed (awarded XP), missed (failed), pending_vote (awaiting decision)

---

### 6. fines
Consequences created from missed check-ins.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | Fine ID |
| check_in_id | uuid | | FK → check_ins.id CASCADE | Source |
| pack_id | uuid | | FK → packs.id CASCADE | Context |
| user_id | uuid | | FK → users.id CASCADE | Fined user |
| amount | integer | | NOT NULL | Cents |
| status | text | 'pending' | CHECK: pending/enforced/appealed/cancelled | Lifecycle |
| voting_ends_at | timestamp | NULL | | Vote window end |
| created_at | timestamp | NOW() | NOT NULL | |
| updated_at | timestamp | | | Auto-updated |

**Indexes:** check_in_id, pack_id, user_id, status, created_at

---

### 7. fine_votes
Individual votes on whether to enforce fines.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | Vote ID |
| fine_id | uuid | | FK → fines.id CASCADE | Fine being voted |
| voter_id | uuid | | FK → users.id CASCADE | Voter |
| vote | boolean | | NOT NULL | true = enforce, false = dismiss |
| created_at | timestamp | NOW() | NOT NULL | Vote time |

**Indexes:** fine_id, voter_id, created_at

---

### 8. phone_jails
Screen time lock sessions.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | Jail ID |
| user_id | uuid | | FK → users.id CASCADE | Locked user |
| pack_id | uuid | | FK → packs.id CASCADE | Context |
| duration_minutes | integer | | NOT NULL | Lock duration |
| blocked_apps | text[] | NULL | | App bundle IDs |
| started_at | timestamp | NOW() | NOT NULL | Start time |
| ended_at | timestamp | NULL | | Unlock time |
| reason | text | NULL | | Why locked |
| created_at | timestamp | NOW() | | |

**Indexes:** user_id, pack_id, started_at

---

### 9. punishments
Executed consequences (fines or jail).

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | Punishment ID |
| user_id | uuid | | FK → users.id CASCADE | Recipient |
| pack_id | uuid | | FK → packs.id CASCADE | Context |
| check_in_id | uuid | NULL | FK → check_ins.id CASCADE | Source |
| type | text | | CHECK: fine/jail | Type |
| amount | integer | | NOT NULL | Cents (fine) or minutes (jail) |
| status | text | 'pending' | CHECK: pending/served/appealed/cancelled | State |
| enforced_by | uuid | NULL | FK → users.id SET NULL | Admin who enforced |
| created_at | timestamp | NOW() | NOT NULL | |
| completed_at | timestamp | NULL | | Completion time |

**Indexes:** user_id, pack_id, status, type

---

### 10. transactions
Payment flows and financial events.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | Transaction ID |
| user_id | uuid | | FK → users.id CASCADE | User |
| pack_id | uuid | NULL | FK → packs.id SET NULL | Context |
| type | text | | CHECK: fine_payment/reward_payout/powerup_purchase | |
| amount | integer | | NOT NULL | Cents |
| provider | text | NULL | CHECK: stripe/cashapp/venmo | Payment provider |
| status | text | 'pending' | CHECK: pending/success/failed | State |
| external_id | text | NULL | | Provider transaction ID |
| created_at | timestamp | NOW() | NOT NULL | |
| completed_at | timestamp | NULL | | Completion time |

**Indexes:** user_id, pack_id, status, type, created_at

---

### 11. powerups
Purchasable or earned boosts.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | Powerup ID |
| name | text | | UNIQUE NOT NULL | e.g., "Shield", "Double XP" |
| description | text | NULL | | Effect description |
| rarity | text | 'common' | CHECK: common/rare/epic | |
| cost | integer | | NOT NULL | Cents |
| duration_seconds | integer | NULL | | NULL = permanent |
| created_at | timestamp | NOW() | | |

---

### 12. user_powerups
Inventory of acquired powerups.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | |
| user_id | uuid | | FK → users.id CASCADE | Owner |
| powerup_id | uuid | | FK → powerups.id CASCADE | |
| status | text | 'active' | CHECK: active/expired/used | |
| obtained_at | timestamp | NOW() | NOT NULL | |
| expires_at | timestamp | NULL | | NULL = no expiry |
| used_at | timestamp | NULL | | Usage timestamp |

**Indexes:** user_id, status

---

### 13. feed_events
Social activity log with visibility tiers.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | Event ID |
| pack_id | uuid | | FK → packs.id CASCADE | Context |
| user_id | uuid | | FK → users.id CASCADE | Actor |
| event_type | text | | CHECK: checkin_success/fine_voted/jail_served/level_up/powerup_used/pack_milestone | |
| metadata | jsonb | NULL | | Context data |
| visibility | text | 'pack' | CHECK: private/pack/public | |
| created_at | timestamp | NOW() | NOT NULL | |

**Indexes:** pack_id, user_id, event_type, visibility, created_at  
**Visibility:** private (user+admins), pack (members), public (all)

---

### 14. challenge_rooms
Public, time-limited competitions.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | Challenge ID |
| title | text | | NOT NULL | e.g., "30-Day No Snooze" |
| description | text | NULL | | |
| creator_id | uuid | | FK → users.id RESTRICT | Creator |
| entry_fee | integer | 0 | | Cents (optional) |
| prize_pool | integer | 0 | | Accumulates from entries |
| status | text | 'upcoming' | CHECK: upcoming/active/ended | |
| start_date | timestamp | | NOT NULL | |
| end_date | timestamp | | NOT NULL | |
| created_at | timestamp | NOW() | | |

**Indexes:** status, creator_id

---

### 15. challenge_participants
Participation tracking.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | |
| challenge_id | uuid | | FK → challenge_rooms.id CASCADE | |
| user_id | uuid | | FK → users.id CASCADE | |
| progress | integer | 0 | | 0-100% |
| eliminated | boolean | false | | Dropped out |
| earned | integer | 0 | | Prize share |
| created_at | timestamp | NOW() | | |
| | | | UNIQUE(challenge_id, user_id) | |

**Indexes:** challenge_id, user_id

---

### 16. notifications
Push notification records.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | |
| user_id | uuid | | FK → users.id CASCADE | Recipient |
| type | text | | NOT NULL | vote_request, fine_paid, etc. |
| message | text | | NOT NULL | Content |
| is_read | boolean | false | NOT NULL | |
| related_entity_id | uuid | NULL | | Link to fine, check_in, etc. |
| created_at | timestamp | NOW() | NOT NULL | |

**Indexes:** user_id, is_read, created_at

---

### 17. reactions
Emoji reactions to content.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | |
| user_id | uuid | | FK → users.id CASCADE | Reactor |
| check_in_id | uuid | NULL | FK → check_ins.id CASCADE | |
| feed_event_id | uuid | NULL | FK → feed_events.id CASCADE | |
| emoji | text | | NOT NULL | e.g., "🔥" |
| created_at | timestamp | NOW() | NOT NULL | |

**Indexes:** user_id, check_in_id, feed_event_id, created_at

---

### 18. comments
Text comments on activities.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | |
| user_id | uuid | | FK → users.id CASCADE | Commenter |
| check_in_id | uuid | NULL | FK → check_ins.id CASCADE | |
| feed_event_id | uuid | NULL | FK → feed_events.id CASCADE | |
| content | text | | NOT NULL | Comment text |
| created_at | timestamp | NOW() | NOT NULL | |
| updated_at | timestamp | | | Auto-updated |

---

### 19. reputation_log
Voting integrity audit trail.

| Column | Type | Default | Constraints | Notes |
|--------|------|---------|-------------|-------|
| id | uuid | gen_random_uuid() | PK | |
| voter_id | uuid | | FK → users.id CASCADE | Subject |
| action | text | | CHECK: fair_vote/false_vote/appeal_upheld | |
| delta | integer | | NOT NULL | XP change |
| reason | text | NULL | | Explanation |
| created_at | timestamp | NOW() | NOT NULL | |

**Indexes:** voter_id, action

---

## Foreign Key Relationships

```
users (1) ──────┬────── (M) pack_members
                ├────── (M) packs (as creator)
                ├────── (M) goals (as creator)
                ├────── (M) check_ins
                ├────── (M) fines
                ├────── (M) fine_votes
                ├────── (M) punishments
                ├────── (M) phone_jails
                ├────── (M) transactions
                ├────── (M) user_powerups
                ├────── (M) feed_events
                ├────── (M) notifications
                ├────── (M) challenge_rooms (as creator)
                ├────── (M) challenge_participants
                ├────── (M) reactions
                ├────── (M) comments
                └────── (M) reputation_log

packs (1) ──────┬────── (M) pack_members
               ├────── (M) goals
               ├────── (M) check_ins
               ├────── (M) fines
               ├────── (M) punishments
               ├────── (M) phone_jails
               ├────── (M) transactions
               ├────── (M) feed_events
               └────── (M) challenge_participants

goals (1) ──────┬────── (M) check_ins
               └────── (M) fines

check_ins (1) ──────┬────── (M) reactions
                   ├────── (M) comments
                   └────── (M) fines

fines (1) ──────┬────── (M) fine_votes
               └────── (M) punishments

powerups (1) ────────── (M) user_powerups

feed_events (1) ┬────── (M) reactions
               └────── (M) comments

challenge_rooms (1) ───── (M) challenge_participants
```

---

## Data Flow: Key Sequences

### Sequence 1: Successful Check-in
```
1. User submits check_in → INSERT check_ins (status='pending_vote')
2. TRIGGER: on_check_in_success
   - Call detect_cheating() → false
   - Call calculate_streak()
   - award_xp(user_id, pack_id, 10 + streak_bonus)
   - UPDATE users.xp, users.level
   - UPDATE packs.xp, packs.level
   - INSERT feed_events (event_type='checkin_success')
   - TRIGGER: on_user_level_up (if level changed)
     → INSERT feed_events (event_type='level_up')
3. Real-time subscription broadcasts to pack members
```

### Sequence 2: Missed Check-in & Voting
```
1. Check-in deadline passes, user didn't submit
2. Create fine: INSERT fines (status='pending')
3. TRIGGER: on_fine_created
   → INSERT notifications for all pack members (type='vote_request')
4. Pack members vote: INSERT fine_votes
5. Admin or automation: UPDATE fines (status='enforced')
6. TRIGGER: on_fine_enforced
   → INSERT feed_events (event_type='fine_voted')
   → INSERT punishments (type='fine' or 'jail')
   → If jail: INSERT phone_jails
7. Broadcast feed event + lock user's apps
```

### Sequence 3: Cheating Detection
```
1. User submits check_in #1 at 10:00 AM
2. User submits check_in #2 at 10:02 AM (same goal)
3. TRIGGER: on_check_in_success
   - Call detect_cheating() → true (within 5 mins)
   - UPDATE check_ins SET status='missed' (both marked failed)
   - No XP awarded
   - Mark user for reputation review
```

---

## Indexes Summary (18+ total)

**By Table:**
- users: 3 (username, email, created_at)
- packs: 3 (creator_id, status, created_at)
- pack_members: 4 (pack_id, user_id, role, is_active)
- goals: 4 (pack_id, creator_id, active, created_at)
- check_ins: 6 (goal_id, user_id, pack_id, status, created_at, composite pack+user+date)
- fines: 5 (check_in_id, pack_id, user_id, status, created_at)
- fine_votes: 3 (fine_id, voter_id, created_at)
- phone_jails: 3 (user_id, pack_id, started_at)
- punishments: 4 (user_id, pack_id, status, type)
- transactions: 5 (user_id, pack_id, status, type, created_at)
- user_powerups: 2 (user_id, status)
- feed_events: 5 (pack_id, user_id, event_type, visibility, created_at)
- challenge_rooms: 2 (status, creator_id)
- challenge_participants: 2 (challenge_id, user_id)
- notifications: 3 (user_id, is_read, created_at)
- reputation_log: 2 (voter_id, action)
- reactions: 4 (user_id, check_in_id, feed_event_id, created_at)
- comments: 3 (user_id, check_in_id, feed_event_id)

---

## Triggers Summary (8 total)

| Trigger | Function | Event | Purpose |
|---------|----------|-------|---------|
| update_*_timestamp | update_timestamp() | BEFORE UPDATE | Auto-update modified_at |
| on_check_in_success_trigger | on_check_in_success() | BEFORE UPDATE check_ins | Award XP, detect cheating, create feed event |
| on_user_xp_change_trigger | on_user_xp_change() | BEFORE UPDATE users | Recalculate user level |
| on_pack_xp_change_trigger | on_pack_xp_change() | BEFORE UPDATE packs | Recalculate pack level |
| on_fine_enforced_trigger | on_fine_enforced() | AFTER UPDATE fines | Create feed event on enforcement |
| on_user_level_up_trigger | on_user_level_up() | AFTER UPDATE users | Create level-up feed event |
| on_fine_created_trigger | on_fine_created() | AFTER INSERT fines | Send vote notifications |

---

## Functions Summary (8 total)

| Function | Returns | Purpose |
|----------|---------|---------|
| calculate_streak(user_id, pack_id) | integer | Count consecutive successful check-ins |
| calculate_user_level(xp) | integer | Derive level from XP (100 XP per level) |
| calculate_pack_level(xp) | integer | Derive level from XP (500 XP per level) |
| calculate_vote_weight(reputation_xp) | numeric | Vote multiplier 0.5x–2.0x |
| detect_cheating(user_id, goal_id) | boolean | Flag duplicates within 5 mins |
| award_xp(user_id, pack_id, amount, reason) | table | Atomic XP award with logging |
| get_feed_for_user(user_id, limit, offset) | table | Visibility-filtered feed |
| enforce_punishment(punishment_id, enforcer_id) | table | Execute fine/jail |

---

## Performance Considerations

- **Composite indexes** on frequently joined columns (pack_id + created_at)
- **Partial indexes** on status columns (e.g., WHERE status='pending')
- **Foreign key indexes** for referential integrity
- **Materialized views** for leaderboards (future)

---

**Schema Version:** 1.0 | Last Updated: January 2025

