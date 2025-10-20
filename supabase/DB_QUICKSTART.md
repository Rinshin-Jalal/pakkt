# Pakkt Database - Quick Start Guide

**TL;DR:** Everything you need to know about the database at a glance.

---

## 🚀 Getting Started (60 seconds)

```bash
# 1. Link to your Supabase project
cd /Users/rinshin/Code/pakkt
supabase link --project-id YOUR_PROJECT_ID

# 2. Apply migrations
supabase db push

# 3. Done! Your database is ready
```

---

## 📋 Core Tables (19 total)

### Users & Groups
- **users** – Profiles, XP, coins, streaks
- **packs** – Group accountability (3–10 friends)
- **pack_members** – Membership with role (admin/member)

### Goals & Submissions
- **goals** – Pack commitments (gym, study, etc.)
- **check_ins** – Daily proof (success/missed)

### Voting & Consequences
- **fines** – Missed check-in consequences
- **fine_votes** – Democratic voting
- **punishments** – Executed consequences
- **phone_jails** – Screen time locks

### Engagement
- **reactions** – Emoji reactions
- **comments** – Text comments
- **feed_events** – Social activity log (private/pack/public)

### Economy
- **transactions** – Payment flows
- **powerups** – Boosts (shields, double XP)
- **user_powerups** – Inventory

### Challenges & Notifications
- **challenge_rooms** – Public competitions
- **challenge_participants** – Tracking
- **notifications** – Push alerts
- **reputation_log** – Voting integrity audit

---

## 🎮 XP System at a Glance

**User XP:**
- ✅ +10 check-in
- ✅ +5 streak bonus
- ❌ -20 missed
- 🚨 -50 cheating

**Levels:** 1 XP → Level 1, 100 XP → Level 2, 200 XP → Level 3, etc.

**Pack XP:** Sum of member XP (reset on daily failures)

---

## 🗳️ Democratic Voting

1. User misses check-in → Fine created
2. Pack notified → Members vote (YES/NO)
3. Majority wins (50% + 1)
4. If YES → Punishment executed
5. Audit trail in reputation_log

**Vote Weight:** 0.5x–2.0x based on reputation XP

---

## 🔒 Security (RLS Policies)

| Table | Read | Write |
|-------|------|-------|
| users | self | self |
| packs | members/creator | admin |
| check_ins | pack members | self |
| fines | pack members | admin |
| feed_events | visibility-based | triggers only |
| notifications | self | system |

---

## 📡 Real-time Subscriptions

Live updates on:
- feed_events (social activity)
- check_ins (submissions)
- fine_votes (voting)
- notifications (alerts)
- reactions, comments, phone_jails

---

## ⚡ Key Functions

```sql
-- Calculate consecutive check-ins
SELECT calculate_streak(user_id, pack_id);

-- Get user level from XP
SELECT calculate_user_level(xp);

-- Get vote multiplier (0.5x–2.0x)
SELECT calculate_vote_weight(reputation_xp);

-- Detect cheating (within 5 mins)
SELECT detect_cheating(user_id, goal_id);

-- Award XP atomically
SELECT award_xp(user_id, pack_id, amount);

-- Get filtered feed
SELECT * FROM get_feed_for_user(user_id, limit, offset);
```

---

## 🔧 Common Queries

### Get User's Packs
```sql
SELECT p.* FROM packs p
JOIN pack_members pm ON p.id = pm.pack_id
WHERE pm.user_id = '<user_id>' AND pm.is_active = true;
```

### Get Pack Feed
```sql
SELECT * FROM feed_events
WHERE pack_id = '<pack_id>'
AND visibility IN ('pack', 'public')
ORDER BY created_at DESC
LIMIT 50;
```

### Pending Fines
```sql
SELECT f.*, COUNT(fv.id) as votes
FROM fines f
LEFT JOIN fine_votes fv ON f.id = fv.fine_id
WHERE f.pack_id = '<pack_id>'
AND f.status = 'pending'
GROUP BY f.id
ORDER BY f.voting_ends_at ASC;
```

### User Stats
```sql
SELECT 
  u.username,
  u.xp,
  u.level,
  u.streak_count,
  COUNT(DISTINCT ci.id) as total_check_ins,
  COUNT(DISTINCT CASE WHEN ci.status = 'success' THEN ci.id END) as successful_check_ins
FROM users u
LEFT JOIN check_ins ci ON u.id = ci.user_id
WHERE u.id = '<user_id>'
GROUP BY u.id;
```

---

## 🧪 Testing Workflow

```bash
# Connect to Supabase SQL editor
open https://app.supabase.com/project/YOUR_PROJECT_ID/sql/new

# Run test from TESTING.md
# - CRUD operations
# - RLS policies
# - Function tests
# - Trigger verification

# Local testing
psql postgresql://postgres:password@localhost:5432/postgres < test.sql
```

---

## 📊 Performance Tips

- Use **indexes** for lookups (already created)
- Filter by **status** and **pack_id** first
- Use **created_at DESC** for latest items
- Composite indexes on **(pack_id, created_at)**

---

## 🚨 Common Issues

**"No rows returned" on queries?**
→ Check RLS policies with `SET request.jwt.claims`

**XP not updating?**
→ Verify triggers fired: `SELECT * FROM pg_trigger WHERE tgrelname = 'check_ins'`

**Feed events not showing?**
→ Check visibility (private/pack/public)

**Real-time not working?**
→ Ensure table is in `pakkt_realtime` publication

---

## 📖 More Info

- **README.md** – Full documentation
- **SCHEMA_SUMMARY.md** – Detailed tables & relationships
- **TESTING.md** – Comprehensive test suite
- **Config:** supabase/config.toml

---

**Last Updated:** January 2025  
**Schema Version:** 1.0  
**PostgreSQL:** 15+

