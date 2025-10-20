# Pakkt Database Quick Start

## 5-Minute Setup

### 1. Apply Migrations
```bash
cd supabase
supabase db push
```

### 2. Create Test Users
Go to **Supabase Dashboard** → **Auth** → **Users** → **+ Create New User**
- Create 3-4 test users (alice@test.com, bob@test.com, etc.)
- Note their UUIDs

### 3. Test a Check-In
Replace `<pack-id>`, `<goal-id>`, `<user-uuid>` with real values:

```sql
-- Create check-in (triggers XP +10, streak calc, feed event)
INSERT INTO check_ins(pack_id, goal_id, user_id, note, at)
VALUES('<pack-id>', '<goal-id>', '<user-uuid>', 'Test check-in', now())
RETURNING id, streak_after;

-- Verify XP increased
SELECT user_xp FROM users WHERE id = '<user-uuid>';
```

## What You Built

✅ **15 Tables**: users, packs, pack_members, goals, check_ins, fines, fine_votes, phone_jails, reactions, comments, feed_events, notifications, reputation_log, cheating_reports

✅ **13 Functions**: Authorization (is_pack_member, has_pack_role), XP (calculate_vote_weight, calculate_streak), Events (add_feed_event, add_reputation_log), Cheating (detect_cheating)

✅ **8 Triggers**: Auto XP, weighted votes, streak, cheating detection, payment processing

✅ **11 RLS Policies**: Private pack model (members-only by default)

✅ **18 Indexes**: Optimized queries for pack/user/feed

## Key Features

### XP System
- **+10** per check-in
- **+5** bonus for streak
- **-50** for cheating
- Affects vote weight (0.5–2.0x)

### Democratic Punishment
- Votes weighted by voter XP
- Requires majority + minimum votes to pass
- All votes logged for audit

### Cheating Detection
- Auto-flags duplicate check-ins (within 5 mins)
- Creates `cheating_reports` (pending status)
- Penalizes with -50 XP

### Social Feed
- Visibility levels: private, pack, public
- Events: check_in_success, fine_enforced, level_up, pack_milestone
- RLS-scoped (auto-filters based on membership)

## File Structure

```
supabase/
├── migrations/
│   ├── 20251020_000001_extensions.sql       # Enable pgcrypto, uuid-ossp
│   ├── 20251020_000002_types.sql            # Enum types
│   ├── 20251020_000003_tables.sql           # 15 tables + FKs + cascades
│   ├── 20251020_000004_helpers.sql          # Helper functions
│   ├── 20251020_000005_triggers.sql         # Triggers + automation
│   ├── 20251020_000006_policies.sql         # RLS policies
│   ├── 20251020_000007_indexes.sql          # Performance indexes
│   └── 20251020_000008_seed_dev.sql         # Dev fixtures (optional)
├── README.md                                 # Full documentation
└── (no .gitignore needed; Supabase manages)

SCHEMA_SUMMARY.md                            # Complete overview
TESTING.md                                   # Test cases + debugging
```

## Usage in Frontend

```typescript
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(URL, ANON_KEY);

// Create a pack
const { data: pack } = await supabase.from('packs').insert({
  name: 'Morning Club',
  timezone: 'America/New_York'
}).select().single();

// Insert a check-in (triggers XP, streak, feed)
const { data: checkIn } = await supabase.from('check_ins').insert({
  pack_id: pack.id,
  goal_id: goalId,
  user_id: userId,
  note: 'Done!'
}).select('id, streak_after').single();

// Subscribe to real-time updates
supabase
  .channel(`pack:${pack.id}`)
  .on('postgres_changes', {
    event: 'INSERT',
    schema: 'public',
    table: 'check_ins',
    filter: `pack_id=eq.${pack.id}`
  }, (payload) => console.log('New check-in:', payload.new))
  .subscribe();

// Read feed (RLS auto-filters by visibility + membership)
const { data: feed } = await supabase
  .from('feed_events')
  .select('*')
  .eq('pack_id', packId)
  .order('created_at', { ascending: false })
  .limit(50);
```

## Testing

See **TESTING.md** for:
- CRUD tests
- RLS allow/deny cases
- XP & reputation flow
- Democratic voting
- Cheating detection
- Feed visibility
- Performance (EXPLAIN ANALYZE)
- Real-time subscriptions

### Quick Test (SQL)
```bash
# Create a check-in and verify XP increases
supabase db query
```

```sql
-- 1. Verify user exists
SELECT id, user_xp FROM users WHERE id = '<uuid>' LIMIT 1;

-- 2. Create check-in
INSERT INTO check_ins(pack_id, goal_id, user_id, at)
VALUES('<pack-id>', '<goal-id>', '<uuid>', now());

-- 3. Check XP increased
SELECT user_xp FROM users WHERE id = '<uuid>';

-- 4. Check feed event created
SELECT event_type, xp_change FROM feed_events 
WHERE user_id = '<uuid>' ORDER BY created_at DESC LIMIT 1;
```

## Common Commands

```bash
# Start local Supabase
supabase start

# Apply migrations
supabase db push

# Reset database (WARNING: destructive)
supabase db reset

# View logs
supabase logs server

# Stop local Supabase
supabase stop

# Link to production (careful!)
supabase link --project-ref <project-id>
supabase db push --linked
```

## Debugging

### RLS denying valid queries?
- Verify `auth.uid()` matches user UUID in DB
- Check policies: `SELECT * FROM pg_policies WHERE tablename = 'check_ins'`

### XP not updating?
- Verify trigger: `SELECT * FROM pg_trigger WHERE tgname LIKE 'after_check_in%'`
- Check function: `SELECT proname FROM pg_proc WHERE proname = 'after_check_in'`

### Vote weight always 1.0?
- Update user XP: `UPDATE users SET user_xp = 500 WHERE id = '<uuid>'`
- Test weight: `SELECT public.calculate_vote_weight('<uuid>', '<pack-id>')`

### Cheating detection not triggering?
- Insert duplicates within 5 mins, same goal, same user
- Check `cheating_reports` table

## Production Checklist

- [ ] Database backups enabled (Supabase dashboard)
- [ ] RLS policies reviewed and tested
- [ ] Storage buckets configured for photo uploads
- [ ] Real-time publication settings configured
- [ ] Performance indexes verified (EXPLAIN ANALYZE)
- [ ] Secrets stored in GitHub Secrets / env vars
- [ ] Monitoring/logging enabled (Supabase logs)

## Support

- **Full Schema Docs**: `supabase/README.md`
- **Test Suite**: `TESTING.md`
- **Architecture**: `SCHEMA_SUMMARY.md`
- **Supabase Docs**: https://supabase.com/docs

---

**Status**: ✅ Complete (8 migrations, 15 tables, 13 functions, 8 triggers, 11 RLS policies, 18 indexes)

**Next**: Connect frontend, run tests, monitor performance.

