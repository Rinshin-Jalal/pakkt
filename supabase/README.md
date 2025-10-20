# Pakkt Supabase Database

## Overview

Pakkt's backend database is built on **Supabase PostgreSQL** with:
- **Private pack model**: All content is scoped to pack members
- **XP reputation system**: User and pack XP tied to behavior
- **Democratic punishment**: Fine votes weighted by voter reputation
- **Social feed**: Public/pack/private event visibility for dopamine-driven accountability
- **Cheating detection**: Auto-flagging suspicious patterns
- **Row-level security (RLS)**: Member/admin/owner authorization

## Architecture

### Identity Model
- **Primary**: `auth.users` (managed by Supabase Auth)
- **Profile**: `public.users` (1:1 relationship, auto-created via trigger)

### Privacy Model
- **Packs**: Private, only members can read/write
- **Content**: All check-ins, fines, comments, reactions scoped to pack members
- **Feed**: Public/pack/private visibility levels

## Migrations

Located in `supabase/migrations/`:

1. **`20251020_000001_extensions.sql`** – Enable pgcrypto, uuid-ossp
2. **`20251020_000002_types.sql`** – Enum types (pack_role, fine_status, event_type, etc.)
3. **`20251020_000003_tables.sql`** – All tables + FKs + cascades + indexes
4. **`20251020_000004_helpers.sql`** – Helper functions (is_pack_member, calculate_vote_weight, etc.)
5. **`20251020_000005_triggers.sql`** – Updated_at, XP gains, vote recompute, cheating detection
6. **`20251020_000006_policies.sql`** – RLS policies (enable + per-table)
7. **`20251020_000007_indexes.sql`** – Performance indexes
8. **`20251020_000008_seed_dev.sql`** – Optional dev fixtures

### Applying Migrations

```bash
# Push to local development
supabase db push

# Deploy to production (via GitHub action or manual)
supabase db push --linked
```

## Tables

### Core

- **users** – User profiles with XP, subscription, stats
- **packs** – Group accountability; XP, settings, pot balance
- **pack_members** – Membership, roles, streaks, stats
- **goals** – Daily/weekly commitments with fines
- **check_ins** – Proof of goal completion; triggers XP + streak

### Enforcement

- **fines** – Punishments issued; votable status
- **fine_votes** – Democratic punishment; XP-weighted votes
- **phone_jails** – Screen time restrictions
- **cheating_reports** – Auto/manual fraud flags

### Social

- **reactions** – Emoji reactions (check_in/fine/comment)
- **comments** – Text commentary on content
- **feed_events** – Social feed; visibility-scoped
- **notifications** – Push/in-app alerts

### Audit

- **reputation_log** – Voting integrity + XP deltas
- **notifications** – User notifications

## Key Functions

### Authorization
- `is_pack_member(pack_id uuid) → boolean`
- `has_pack_role(pack_id uuid, roles text[]) → boolean`

### XP & Reputation
- `calculate_vote_weight(user_id uuid, pack_id uuid) → numeric` – XP-based vote strength (0.5–2.0)
- `calculate_streak(user_id uuid, goal_id uuid, ts timestamptz) → int` – Contiguous days respecting timezone
- `refresh_member_stats(pack_id uuid, user_id uuid) → void` – Recompute totals

### Helpers
- `set_updated_at() → trigger` – Auto-update `updated_at` timestamp
- `add_reputation_log(...) → uuid` – Log voting/behavior events
- `add_feed_event(...) → uuid` – Create social feed entries
- `detect_cheating(check_in_id uuid) → boolean` – Flag suspicious patterns
- `handle_new_auth_user() → trigger` – Bootstrap user profile on auth signup

## Triggers

| Trigger | On | Effect |
|---------|-----|--------|
| `after_check_in_trigger` | INSERT check_ins | XP +10/+5 (streak), streak calc, feed event, cheating check |
| `set_vote_weight_trigger` | BEFORE INSERT fine_votes | Calculate vote weight from voter XP |
| `recompute_fine_votes_trigger_*` | INSERT/UPDATE fine_votes | Recompute fine.passed (weighted majority) |
| `after_fine_payment_trigger` | UPDATE fines.payment_status='paid' | Add to pool balance, user totals |
| `on_auth_user_created_trigger` | INSERT auth.users | Create public.users profile |
| `set_updated_at_*` | BEFORE UPDATE (all tables) | Set updated_at = now() |

## RLS Policies

### Summary
- **Packs**: Only members can read; owner/admin can modify
- **Check-ins**: Only pack members; self-create, admin edit
- **Fines**: Pack members can read; voting restricted to self
- **Feed**: Visibility-gated (public/pack/private)
- **Reputation**: Pack-scoped read; service-role write

**Default**: All tables have RLS enabled; "default deny" unless explicitly allowed.

## Usage Patterns

### Create a Pack
```typescript
const { data } = await supabase
  .from('packs')
  .insert({ name: 'Morning Run Club', timezone: 'America/New_York' })
  .select()
  .single();

// Trigger creates pack_members entry for creator as 'owner'
```

### Check In
```typescript
const { data } = await supabase
  .from('check_ins')
  .insert({
    pack_id: packId,
    goal_id: goalId,
    user_id: userId, // set by RLS to auth.uid()
    note: 'Morning 5k done!'
  })
  .select('id, streak_after')
  .single();

// Trigger:
// 1. Calculate streak_after
// 2. Increment pack_members.total_check_ins
// 3. Add +10 XP (base) + 5 (if streak > 1)
// 4. Create feed_event (check_in_success, pack visibility)
// 5. Check for cheating (duplicate within 5 mins)
```

### Vote on Fine
```typescript
const { data } = await supabase
  .from('fine_votes')
  .insert({
    fine_id: fineId,
    voter_id: userId, // set by RLS
    decision: true // vote yes
  })
  .select('vote_weight')
  .single();

// Trigger:
// 1. Set vote_weight from voter's XP
// 2. Recompute fines.passed = (total_weight >= required && yes > 50%)
// 3. Log in reputation_log (vote_yes action)
```

### Read Pack Feed
```typescript
const { data } = await supabase
  .from('feed_events')
  .select('*')
  .eq('pack_id', packId)
  .in('visibility', ['public', 'pack']) // RLS auto-filters
  .order('created_at', { ascending: false })
  .limit(20);
```

### Subscribe to Real-Time Changes
```typescript
const channel = supabase
  .channel(`pack:${packId}:changes`)
  .on('postgres_changes', {
    event: '*', // INSERT, UPDATE, DELETE
    schema: 'public',
    table: 'check_ins',
    filter: `pack_id=eq.${packId}`
  }, (payload) => {
    console.log('Check-in changed:', payload);
  })
  .subscribe();
```

## XP System

### Earning
- **+10** per check-in
- **+5** bonus for streak continuation (streak > 1)
- **-20** when punishment enforced
- **-50** when cheating detected

### Effects
- Unlocks cosmetics, reduced fines, vote weight (0.5–2.0 range)
- Higher XP users' posts rank higher in feed
- Feeds pack reputation for recommendations

## Democratic Punishment

1. Fine created (manually or auto on miss)
2. `required_votes` set (e.g., 2 for 3-person pack)
3. Voting period opens (~2 hours)
4. Each vote weighted by `(voter_xp / pack_avg_xp)`, clamped to 0.5–2.0
5. If (total_weight >= required && yes_votes > 50%), `fines.passed = true`
6. Enforcement triggers payment/jail/freeze

## Cheating Detection

**Auto-flagged** if:
- Multiple check-ins within 5 minutes (same goal, same user)
- (Future: photo hash collision, location spoofing)

**Result**:
- `cheating_reports` row created (pending)
- `-50 XP` reputation log entry
- Flagged for manual admin review + community vote

## Performance

### Indexes
- All FK columns indexed
- Composite indexes on common queries: `(pack_id, created_at desc)`, `(user_id, created_at desc)`
- GIN index on `notifications.data` for JSONB queries
- Unique indexes on memberships, reactions

### Query Examples
```sql
-- Latest 10 check-ins in pack
SELECT * FROM check_ins WHERE pack_id = ? ORDER BY at DESC LIMIT 10;

-- Open fines with vote status
SELECT f.*, count(fv.id), sum(fv.vote_weight) 
FROM fines f LEFT JOIN fine_votes fv ON fv.fine_id = f.id
WHERE f.pack_id = ? AND f.status = 'open'
GROUP BY f.id;

-- User feed
SELECT * FROM feed_events 
WHERE user_id = ? AND visibility IN ('public', 'private')
ORDER BY created_at DESC LIMIT 50;
```

## Backups & Recovery

### Automated Backups
Supabase performs daily backups. Access via Dashboard → Backups.

### Manual Backup
```bash
supabase db dump -f backup.sql
```

### Restore from Backup
```bash
supabase db reset
supabase db push
```

## Monitoring

### Logs
```bash
supabase logs server # Postgres logs
supabase logs realtime # Realtime server
```

### Advisors (RLS/Performance Issues)
```bash
supabase db diagnostics
```

## Development Workflow

1. **Create migration**:
   ```bash
   supabase migration new add_my_feature
   ```
   Edit `supabase/migrations/YYYYMMDD_HHMMSS_add_my_feature.sql`

2. **Test locally**:
   ```bash
   supabase start
   supabase db push
   # Run tests
   supabase stop
   ```

3. **Link to production** (careful!):
   ```bash
   supabase link --project-ref abc123xyz
   supabase db push --linked # Creates migration on prod
   ```

## Security

### RLS is Enforced
- Every table has RLS enabled
- Default-deny policies
- Verified via `public.has_pack_role()` and `public.is_pack_member()`

### Service Role
- Only used by backend (Node.js/webhooks)
- Never expose to client
- Can bypass RLS for admin operations

### Secrets
- Store API keys in `.env.local` (dev) / GitHub Secrets (CI/CD)
- Use service role key only on backend

## Troubleshooting

See [TESTING.md](./TESTING.md) for detailed test cases and debugging.

### Common Issues
- **RLS "permission denied"**: Check `auth.uid()` matches row user_id
- **Trigger not firing**: Verify with `SELECT * FROM pg_trigger`
- **Performance**: Run `EXPLAIN ANALYZE` on slow queries
- **XP not updating**: Check `after_check_in_trigger` exists

## References
- [Supabase Docs](https://supabase.com/docs)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [RLS Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [Realtime](https://supabase.com/docs/guides/realtime)
