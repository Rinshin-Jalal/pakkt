# PAKKT - CLOUDFLARE WORKERS BACKEND TODO

> **Goal:** Build a blazing-fast, globally distributed edge API for real-time accountability

---

## 🌍 WHY CLOUDFLARE WORKERS?

- **Edge performance:** <50ms latency worldwide
- **Serverless:** No servers to manage, auto-scaling
- **Cost-effective:** Free tier: 100K requests/day
- **TypeScript native:** Type-safe development
- **KV Storage:** Global key-value store for caching
- **Durable Objects:** Stateful WebSocket connections (real-time)
- **Integrated:** Works seamlessly with Cloudflare R2 (image storage)

---

## 📋 PROJECT SETUP

### **A. Initial Configuration**

- [ ] Install Wrangler CLI: `npm install -g wrangler`
- [ ] Login to Cloudflare: `wrangler login`
- [ ] Create new project: `wrangler init pakkt-api`
- [ ] Choose TypeScript template
- [ ] Initialize Git: `git init`
- [ ] Create `.gitignore`:
  ```
  node_modules/
  .wrangler/
  .dev.vars
  dist/
  ```

- [ ] Install dependencies:
  ```bash
  npm install @supabase/supabase-js
  npm install hono  # Fast web framework for Workers
  npm install zod   # Schema validation
  npm install jose  # JWT handling
  npm install @sentry/cloudflare  # Error tracking
  ```

- [ ] Create `wrangler.toml`:
  ```toml
  name = "pakkt-api"
  main = "src/index.ts"
  compatibility_date = "2024-01-01"

  [env.production]
  route = "api.pakkt.app/*"
  vars = { ENVIRONMENT = "production" }

  [env.development]
  vars = { ENVIRONMENT = "development" }

  [[kv_namespaces]]
  binding = "CACHE"
  id = "your_kv_namespace_id"

  [[r2_buckets]]
  binding = "IMAGES"
  bucket_name = "pakkt-images"
  ```

---

### **B. Project Structure**

Create this folder structure:

```
pakkt-api/
├── src/
│   ├── index.ts                 # Main entry point
│   ├── routes/
│   │   ├── auth.ts              # Authentication routes
│   │   ├── users.ts             # User management
│   │   ├── packs.ts             # Pack CRUD
│   │   ├── goals.ts             # Goal management
│   │   ├── checkins.ts          # Check-in operations
│   │   ├── fines.ts             # Fine system
│   │   ├── jail.ts              # Phone jail
│   │   ├── reactions.ts         # Reactions
│   │   ├── comments.ts          # Comments
│   │   └── notifications.ts     # Push notifications
│   ├── middleware/
│   │   ├── auth.ts              # JWT validation
│   │   ├── rateLimit.ts         # Rate limiting
│   │   ├── validation.ts        # Request validation
│   │   ├── cors.ts              # CORS headers
│   │   └── errorHandler.ts     # Global error handling
│   ├── services/
│   │   ├── supabase.ts          # Supabase client
│   │   ├── stripe.ts            # Payment processing
│   │   ├── apns.ts              # Apple Push Notifications
│   │   └── imageUpload.ts       # R2 image handling
│   ├── lib/
│   │   ├── jwt.ts               # JWT utilities
│   │   ├── crypto.ts            # Encryption helpers
│   │   └── validation.ts        # Zod schemas
│   ├── types/
│   │   ├── index.ts             # TypeScript types
│   │   └── env.ts               # Environment types
│   └── utils/
│       ├── errors.ts            # Custom error classes
│       └── responses.ts         # Standardized responses
├── test/
│   └── index.test.ts
├── wrangler.toml
├── package.json
└── tsconfig.json
```

- [ ] Create all folders and files
- [ ] Set up TypeScript config (`tsconfig.json`)

---

## 🔐 ENVIRONMENT VARIABLES & SECRETS

### **A. Create `.dev.vars` (local development)**

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_KEY=your_service_role_key
JWT_SECRET=your_jwt_secret_minimum_32_chars
STRIPE_SECRET_KEY=sk_test_your_stripe_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret
APNS_KEY_ID=your_apns_key_id
APNS_TEAM_ID=your_apple_team_id
APNS_KEY=-----BEGIN PRIVATE KEY-----...
SENTRY_DSN=https://your_sentry_dsn
```

- [ ] Never commit `.dev.vars` to Git!

### **B. Set Production Secrets**

```bash
wrangler secret put SUPABASE_URL
wrangler secret put SUPABASE_ANON_KEY
wrangler secret put SUPABASE_SERVICE_KEY
wrangler secret put JWT_SECRET
wrangler secret put STRIPE_SECRET_KEY
wrangler secret put STRIPE_WEBHOOK_SECRET
wrangler secret put APNS_KEY_ID
wrangler secret put APNS_TEAM_ID
wrangler secret put APNS_KEY
wrangler secret put SENTRY_DSN
```

- [ ] Rotate all secrets before production launch

---

## 🛠️ CORE INFRASTRUCTURE

### **A. Main Entry Point**

- [ ] Create `src/index.ts`:
  ```typescript
  import { Hono } from 'hono';
  import { cors } from 'hono/cors';
  import { logger } from 'hono/logger';
  import { authRoutes } from './routes/auth';
  import { packRoutes } from './routes/packs';
  // ... import all routes
  import { errorHandler } from './middleware/errorHandler';

  const app = new Hono();

  // Global middleware
  app.use('*', cors());
  app.use('*', logger());

  // Health check
  app.get('/health', (c) => c.json({ status: 'ok', timestamp: Date.now() }));

  // Routes
  app.route('/auth', authRoutes);
  app.route('/packs', packRoutes);
  // ... register all routes

  // Error handling
  app.onError(errorHandler);

  export default app;
  ```

### **B. Supabase Client Setup**

- [ ] Create `src/services/supabase.ts`:
  ```typescript
  import { createClient } from '@supabase/supabase-js';

  export function getSupabaseClient(env: Env) {
    return createClient(env.SUPABASE_URL, env.SUPABASE_ANON_KEY, {
      auth: { persistSession: false }
    });
  }

  export function getSupabaseAdminClient(env: Env) {
    return createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_KEY, {
      auth: { persistSession: false }
    });
  }
  ```

### **C. Authentication Middleware**

- [ ] Create `src/middleware/auth.ts`:
  ```typescript
  import { jwtVerify } from 'jose';
  import { Context, Next } from 'hono';

  export async function requireAuth(c: Context, next: Next) {
    const authHeader = c.req.header('Authorization');
    if (!authHeader?.startsWith('Bearer ')) {
      return c.json({ error: 'Unauthorized' }, 401);
    }

    const token = authHeader.substring(7);
    try {
      const secret = new TextEncoder().encode(c.env.JWT_SECRET);
      const { payload } = await jwtVerify(token, secret);
      c.set('userId', payload.sub);
      await next();
    } catch (error) {
      return c.json({ error: 'Invalid token' }, 401);
    }
  }
  ```

### **D. Rate Limiting**

- [ ] Create `src/middleware/rateLimit.ts`:
  ```typescript
  import { Context, Next } from 'hono';

  export async function rateLimit(c: Context, next: Next) {
    const userId = c.get('userId') || c.req.header('CF-Connecting-IP');
    const key = `ratelimit:${userId}`;

    const count = await c.env.CACHE.get(key);
    const limit = 100; // requests per minute

    if (count && parseInt(count) >= limit) {
      return c.json({ error: 'Rate limit exceeded' }, 429);
    }

    await c.env.CACHE.put(key, (parseInt(count || '0') + 1).toString(), {
      expirationTtl: 60 // 1 minute
    });

    await next();
  }
  ```

### **E. Request Validation with Zod**

- [ ] Create `src/lib/validation.ts`:
  ```typescript
  import { z } from 'zod';

  export const CreatePackSchema = z.object({
    name: z.string().min(1).max(50),
    description: z.string().max(200).optional(),
    defaultFineAmount: z.number().min(1).max(20).default(5),
    defaultJailDuration: z.number().min(15).max(60).default(30),
  });

  export const CreateGoalSchema = z.object({
    packId: z.string().uuid(),
    title: z.string().min(1).max(50),
    description: z.string().max(200).optional(),
    checkInTime: z.string().regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/),
    fineAmount: z.number().min(1).max(20).optional(),
    jailDuration: z.number().min(15).max(60).optional(),
    requiresPhoto: z.boolean().default(false),
  });

  export const CreateCheckInSchema = z.object({
    goalId: z.string().uuid(),
    photoUrl: z.string().url().optional(),
    caption: z.string().max(200).optional(),
  });

  // ... more schemas
  ```

- [ ] Create validation middleware:
  ```typescript
  export function validate(schema: z.ZodSchema) {
    return async (c: Context, next: Next) => {
      try {
        const body = await c.req.json();
        const validated = schema.parse(body);
        c.set('validatedData', validated);
        await next();
      } catch (error) {
        if (error instanceof z.ZodError) {
          return c.json({ error: 'Validation failed', details: error.errors }, 400);
        }
        throw error;
      }
    };
  }
  ```

---

## 🔌 API ROUTES IMPLEMENTATION

### **A. Authentication Routes**

- [ ] Create `src/routes/auth.ts`:

**POST `/auth/send-otp`**
```typescript
// Send OTP to phone number via Supabase Auth
app.post('/send-otp', async (c) => {
  const { phoneNumber } = await c.req.json();
  const supabase = getSupabaseClient(c.env);

  const { error } = await supabase.auth.signInWithOtp({
    phone: phoneNumber,
  });

  if (error) throw error;
  return c.json({ message: 'OTP sent' });
});
```

**POST `/auth/verify-otp`**
```typescript
// Verify OTP and return JWT
app.post('/verify-otp', async (c) => {
  const { phoneNumber, code } = await c.req.json();
  const supabase = getSupabaseClient(c.env);

  const { data, error } = await supabase.auth.verifyOtp({
    phone: phoneNumber,
    token: code,
    type: 'sms',
  });

  if (error) throw error;

  // Check if user exists, if not create profile
  const { data: user } = await supabase
    .from('users')
    .select('*')
    .eq('id', data.user.id)
    .single();

  if (!user) {
    // First-time user, needs onboarding
    return c.json({
      accessToken: data.session.access_token,
      needsOnboarding: true
    });
  }

  return c.json({
    accessToken: data.session.access_token,
    user
  });
});
```

**GET `/auth/me`**
```typescript
// Get current user (requires auth)
app.get('/me', requireAuth, async (c) => {
  const userId = c.get('userId');
  const supabase = getSupabaseAdminClient(c.env);

  const { data, error } = await supabase
    .from('users')
    .select('*')
    .eq('id', userId)
    .single();

  if (error) throw error;
  return c.json({ user: data });
});
```

**POST `/auth/logout`**
```typescript
// Logout (clear push token)
app.post('/logout', requireAuth, async (c) => {
  const userId = c.get('userId');
  const supabase = getSupabaseAdminClient(c.env);

  await supabase
    .from('users')
    .update({ push_token: null })
    .eq('id', userId);

  return c.json({ message: 'Logged out' });
});
```

---

### **B. User Routes**

- [ ] Create `src/routes/users.ts`:

**POST `/users/profile`**
```typescript
// Create/update user profile
app.post('/profile', requireAuth, async (c) => {
  const userId = c.get('userId');
  const { username, displayName, bio, avatarUrl } = await c.req.json();
  const supabase = getSupabaseAdminClient(c.env);

  // Check username availability
  const { data: existing } = await supabase
    .from('users')
    .select('id')
    .eq('username', username)
    .neq('id', userId)
    .single();

  if (existing) {
    return c.json({ error: 'Username taken' }, 400);
  }

  const { data, error } = await supabase
    .from('users')
    .upsert({
      id: userId,
      username,
      display_name: displayName,
      bio,
      avatar_url: avatarUrl,
    })
    .select()
    .single();

  if (error) throw error;
  return c.json({ user: data });
});
```

**POST `/users/push-token`**
```typescript
// Update push notification token
app.post('/push-token', requireAuth, async (c) => {
  const userId = c.get('userId');
  const { pushToken } = await c.req.json();
  const supabase = getSupabaseAdminClient(c.env);

  await supabase
    .from('users')
    .update({ push_token: pushToken })
    .eq('id', userId);

  return c.json({ message: 'Push token updated' });
});
```

---

### **C. Pack Routes**

- [ ] Create `src/routes/packs.ts`:

**POST `/packs`**
```typescript
// Create new pack
app.post('/', requireAuth, validate(CreatePackSchema), async (c) => {
  const userId = c.get('userId');
  const data = c.get('validatedData');
  const supabase = getSupabaseAdminClient(c.env);

  // Generate unique invite code
  const inviteCode = generateInviteCode(); // 6-char random

  const { data: pack, error } = await supabase
    .from('packs')
    .insert({
      ...data,
      created_by: userId,
      invite_code: inviteCode,
    })
    .select()
    .single();

  if (error) throw error;

  // Add creator as admin member
  await supabase.from('pack_members').insert({
    pack_id: pack.id,
    user_id: userId,
    role: 'admin',
  });

  return c.json({ pack }, 201);
});
```

**POST `/packs/join`**
```typescript
// Join pack with invite code
app.post('/join', requireAuth, async (c) => {
  const userId = c.get('userId');
  const { inviteCode } = await c.req.json();
  const supabase = getSupabaseAdminClient(c.env);

  // Find pack by invite code
  const { data: pack, error } = await supabase
    .from('packs')
    .select('*')
    .eq('invite_code', inviteCode)
    .single();

  if (error || !pack) {
    return c.json({ error: 'Invalid invite code' }, 404);
  }

  // Check if already member
  const { data: existing } = await supabase
    .from('pack_members')
    .select('id')
    .eq('pack_id', pack.id)
    .eq('user_id', userId)
    .single();

  if (existing) {
    return c.json({ error: 'Already a member' }, 400);
  }

  // Check member limit
  const { count } = await supabase
    .from('pack_members')
    .select('id', { count: 'exact' })
    .eq('pack_id', pack.id);

  if (count >= pack.member_limit) {
    return c.json({ error: 'Pack is full' }, 400);
  }

  // Join pack
  await supabase.from('pack_members').insert({
    pack_id: pack.id,
    user_id: userId,
  });

  return c.json({ pack });
});
```

**GET `/packs/:id`**
```typescript
// Get pack details
app.get('/:id', requireAuth, async (c) => {
  const packId = c.req.param('id');
  const userId = c.get('userId');
  const supabase = getSupabaseAdminClient(c.env);

  // Verify user is member
  const { data: membership } = await supabase
    .from('pack_members')
    .select('*')
    .eq('pack_id', packId)
    .eq('user_id', userId)
    .single();

  if (!membership) {
    return c.json({ error: 'Not a member' }, 403);
  }

  // Get pack with members
  const { data: pack } = await supabase
    .from('packs')
    .select(`
      *,
      members:pack_members(
        user_id,
        role,
        total_check_ins,
        current_streak,
        user:users(id, username, display_name, avatar_url)
      )
    `)
    .eq('id', packId)
    .single();

  return c.json({ pack });
});
```

**GET `/packs`**
```typescript
// Get user's packs
app.get('/', requireAuth, async (c) => {
  const userId = c.get('userId');
  const supabase = getSupabaseAdminClient(c.env);

  const { data: packs } = await supabase
    .from('pack_members')
    .select(`
      pack:packs(
        *,
        members:pack_members(count)
      )
    `)
    .eq('user_id', userId)
    .eq('is_active', true);

  return c.json({ packs: packs.map(p => p.pack) });
});
```

---

### **D. Goal Routes**

- [ ] Create `src/routes/goals.ts`:

**POST `/goals`**
```typescript
// Create goal
app.post('/', requireAuth, validate(CreateGoalSchema), async (c) => {
  const userId = c.get('userId');
  const data = c.get('validatedData');
  const supabase = getSupabaseAdminClient(c.env);

  // Verify user is member of pack
  const { data: membership } = await supabase
    .from('pack_members')
    .select('*')
    .eq('pack_id', data.packId)
    .eq('user_id', userId)
    .single();

  if (!membership) {
    return c.json({ error: 'Not a pack member' }, 403);
  }

  const { data: goal, error } = await supabase
    .from('goals')
    .insert({
      ...data,
      user_id: userId,
    })
    .select()
    .single();

  if (error) throw error;
  return c.json({ goal }, 201);
});
```

**GET `/goals`**
```typescript
// Get user's goals (optionally filter by pack)
app.get('/', requireAuth, async (c) => {
  const userId = c.get('userId');
  const packId = c.req.query('packId');
  const supabase = getSupabaseAdminClient(c.env);

  let query = supabase
    .from('goals')
    .select('*')
    .eq('user_id', userId)
    .eq('is_active', true);

  if (packId) {
    query = query.eq('pack_id', packId);
  }

  const { data: goals } = await query;
  return c.json({ goals });
});
```

---

### **E. Check-In Routes**

- [ ] Create `src/routes/checkins.ts`:

**POST `/checkins`**
```typescript
// Submit check-in
app.post('/', requireAuth, validate(CreateCheckInSchema), async (c) => {
  const userId = c.get('userId');
  const { goalId, photoUrl, caption } = c.get('validatedData');
  const supabase = getSupabaseAdminClient(c.env);

  // Get goal details
  const { data: goal } = await supabase
    .from('goals')
    .select('*, pack:packs(*)')
    .eq('id', goalId)
    .single();

  if (!goal || goal.user_id !== userId) {
    return c.json({ error: 'Invalid goal' }, 404);
  }

  // Check if on time (within 30 min window before check_in_time)
  const now = new Date();
  const checkInTime = parseTime(goal.check_in_time);
  const wasOnTime = isWithinCheckInWindow(now, checkInTime);

  // Calculate streak
  const { data: lastCheckIn } = await supabase
    .from('check_ins')
    .select('check_in_date, streak_count')
    .eq('goal_id', goalId)
    .order('check_in_date', { ascending: false })
    .limit(1)
    .single();

  const streakCount = calculateStreak(lastCheckIn, wasOnTime);

  const { data: checkIn, error } = await supabase
    .from('check_ins')
    .insert({
      goal_id: goalId,
      user_id: userId,
      pack_id: goal.pack_id,
      photo_url: photoUrl,
      caption,
      was_on_time: wasOnTime,
      streak_count: streakCount,
    })
    .select()
    .single();

  if (error) throw error;

  // Update user stats
  await supabase
    .from('users')
    .update({
      current_streak: streakCount,
      total_check_ins: supabase.rpc('increment', { row_id: userId }),
    })
    .eq('id', userId);

  // If late, create fine for voting
  if (!wasOnTime) {
    await createFineForVoting(goal, userId);
  }

  return c.json({ checkIn, wasOnTime, streakCount }, 201);
});
```

**GET `/checkins/feed`**
```typescript
// Get pack feed (all check-ins from user's packs)
app.get('/feed', requireAuth, async (c) => {
  const userId = c.get('userId');
  const limit = parseInt(c.req.query('limit') || '50');
  const offset = parseInt(c.req.query('offset') || '0');
  const supabase = getSupabaseAdminClient(c.env);

  // Get user's pack IDs
  const { data: memberships } = await supabase
    .from('pack_members')
    .select('pack_id')
    .eq('user_id', userId);

  const packIds = memberships.map(m => m.pack_id);

  // Get recent check-ins from those packs
  const { data: checkIns } = await supabase
    .from('check_ins')
    .select(`
      *,
      user:users(id, username, display_name, avatar_url),
      goal:goals(title),
      reactions(emoji, user_id),
      comments(count)
    `)
    .in('pack_id', packIds)
    .order('created_at', { ascending: false })
    .range(offset, offset + limit - 1);

  return c.json({ checkIns, hasMore: checkIns.length === limit });
});
```

---

### **F. Fine Routes**

- [ ] Create `src/routes/fines.ts`:

**POST `/fines/:id/vote`**
```typescript
// Vote on fine
app.post('/:id/vote', requireAuth, async (c) => {
  const fineId = c.req.param('id');
  const userId = c.get('userId');
  const { vote } = await c.req.json(); // true = for, false = against
  const supabase = getSupabaseAdminClient(c.env);

  // Get fine details
  const { data: fine } = await supabase
    .from('fines')
    .select('*, pack:packs(*)')
    .eq('id', fineId)
    .single();

  if (!fine) {
    return c.json({ error: 'Fine not found' }, 404);
  }

  // Check if user is pack member (but not the fined user)
  const { data: membership } = await supabase
    .from('pack_members')
    .select('*')
    .eq('pack_id', fine.pack_id)
    .eq('user_id', userId)
    .single();

  if (!membership || userId === fine.user_id) {
    return c.json({ error: 'Cannot vote' }, 403);
  }

  // Record vote
  await supabase
    .from('fine_votes')
    .upsert({
      fine_id: fineId,
      user_id: userId,
      vote,
    });

  // Update vote counts
  const { data: votes } = await supabase
    .from('fine_votes')
    .select('vote')
    .eq('fine_id', fineId);

  const votesFor = votes.filter(v => v.vote).length;
  const votesAgainst = votes.filter(v => !v.vote).length;

  await supabase
    .from('fines')
    .update({ votes_for: votesFor, votes_against: votesAgainst })
    .eq('id', fineId);

  // Check if threshold met
  if (votesFor >= fine.pack.min_votes_for_fine) {
    await supabase
      .from('fines')
      .update({ status: 'active' })
      .eq('id', fineId);

    // Send notification to fined user
    await sendPushNotification(fine.user_id, {
      title: 'FINE ACTIVATED 💸',
      body: `Your pack voted. Pay $${fine.amount} now.`,
    });
  }

  return c.json({ votesFor, votesAgainst });
});
```

**POST `/fines/:id/pay`**
```typescript
// Mark fine as paid (honor system for MVP)
app.post('/:id/pay', requireAuth, async (c) => {
  const fineId = c.req.param('id');
  const userId = c.get('userId');
  const supabase = getSupabaseAdminClient(c.env);

  const { data: fine } = await supabase
    .from('fines')
    .select('*')
    .eq('id', fineId)
    .eq('user_id', userId)
    .single();

  if (!fine) {
    return c.json({ error: 'Fine not found' }, 404);
  }

  await supabase
    .from('fines')
    .update({ status: 'paid', paid_at: new Date().toISOString() })
    .eq('id', fineId);

  // Update user stats
  await supabase.rpc('increment_fines_paid', { user_id: userId, amount: fine.amount });

  return c.json({ message: 'Fine marked as paid' });
});
```

---

### **G. Phone Jail Routes**

- [ ] Create `src/routes/jail.ts`:

**POST `/jail/start`**
```typescript
// Start jail session
app.post('/start', requireAuth, async (c) => {
  const userId = c.get('userId');
  const { goalId, durationMinutes, blockedApps } = await c.req.json();
  const supabase = getSupabaseAdminClient(c.env);

  const scheduledEndAt = new Date(Date.now() + durationMinutes * 60 * 1000);

  const { data: jail, error } = await supabase
    .from('phone_jails')
    .insert({
      user_id: userId,
      goal_id: goalId,
      duration_minutes: durationMinutes,
      blocked_apps: blockedApps,
      scheduled_end_at: scheduledEndAt.toISOString(),
      break_fine_amount: calculateBreakFine(goalId), // 2x goal fine
    })
    .select()
    .single();

  if (error) throw error;

  // Notify pack members
  await notifyPackMembers(jail.pack_id, {
    title: `${username} IS IN JAIL 💀`,
    body: `Locked out for ${durationMinutes} minutes`,
  });

  return c.json({ jail }, 201);
});
```

**POST `/jail/:id/break`**
```typescript
// Break jail (pay 2x fine)
app.post('/:id/break', requireAuth, async (c) => {
  const jailId = c.req.param('id');
  const userId = c.get('userId');
  const supabase = getSupabaseAdminClient(c.env);

  const { data: jail } = await supabase
    .from('phone_jails')
    .select('*')
    .eq('id', jailId)
    .eq('user_id', userId)
    .single();

  if (!jail || jail.status !== 'active') {
    return c.json({ error: 'Invalid jail session' }, 404);
  }

  // Mark jail as broken
  await supabase
    .from('phone_jails')
    .update({
      status: 'broken',
      was_broken: true,
      broken_at: new Date().toISOString(),
      actual_end_at: new Date().toISOString(),
    })
    .eq('id', jailId);

  // Create fine for 2x amount
  await supabase
    .from('fines')
    .insert({
      user_id: userId,
      pack_id: jail.pack_id,
      amount: jail.break_fine_amount,
      reason: `Broke phone jail (${jail.duration_minutes} min)`,
      status: 'active', // No voting needed
    });

  return c.json({ message: 'Jail broken. Pay 2x fine.' });
});
```

**GET `/jail/:id/status`**
```typescript
// Get jail status (for timer sync)
app.get('/:id/status', requireAuth, async (c) => {
  const jailId = c.req.param('id');
  const supabase = getSupabaseAdminClient(c.env);

  const { data: jail } = await supabase
    .from('phone_jails')
    .select('*')
    .eq('id', jailId)
    .single();

  if (!jail) {
    return c.json({ error: 'Not found' }, 404);
  }

  const now = new Date();
  const scheduledEnd = new Date(jail.scheduled_end_at);
  const timeRemaining = Math.max(0, scheduledEnd.getTime() - now.getTime());

  return c.json({
    jail,
    timeRemaining,
    isComplete: timeRemaining === 0
  });
});
```

---

### **H. Reactions & Comments**

- [ ] Create `src/routes/reactions.ts`:

**POST `/reactions`**
```typescript
// Add/remove reaction
app.post('/', requireAuth, async (c) => {
  const userId = c.get('userId');
  const { targetType, targetId, emoji } = await c.req.json();
  const supabase = getSupabaseAdminClient(c.env);

  // Toggle reaction (upsert = add if not exists, delete if exists)
  const { data: existing } = await supabase
    .from('reactions')
    .select('id')
    .eq('user_id', userId)
    .eq('target_type', targetType)
    .eq('target_id', targetId)
    .eq('emoji', emoji)
    .single();

  if (existing) {
    // Remove reaction
    await supabase
      .from('reactions')
      .delete()
      .eq('id', existing.id);
    return c.json({ action: 'removed' });
  } else {
    // Add reaction
    await supabase
      .from('reactions')
      .insert({ user_id: userId, target_type: targetType, target_id: targetId, emoji });
    return c.json({ action: 'added' });
  }
});
```

- [ ] Create `src/routes/comments.ts`:

**POST `/comments`**
```typescript
// Post comment
app.post('/', requireAuth, async (c) => {
  const userId = c.get('userId');
  const { targetType, targetId, content } = await c.req.json();
  const supabase = getSupabaseAdminClient(c.env);

  const { data: comment, error } = await supabase
    .from('comments')
    .insert({ user_id: userId, target_type: targetType, target_id: targetId, content })
    .select(`
      *,
      user:users(id, username, display_name, avatar_url)
    `)
    .single();

  if (error) throw error;
  return c.json({ comment }, 201);
});
```

**GET `/comments`**
```typescript
// Get comments for target
app.get('/', requireAuth, async (c) => {
  const targetType = c.req.query('targetType');
  const targetId = c.req.query('targetId');
  const supabase = getSupabaseAdminClient(c.env);

  const { data: comments } = await supabase
    .from('comments')
    .select(`
      *,
      user:users(id, username, display_name, avatar_url)
    `)
    .eq('target_type', targetType)
    .eq('target_id', targetId)
    .eq('is_deleted', false)
    .order('created_at', { ascending: true });

  return c.json({ comments });
});
```

---

### **I. Notifications (Push via APNS)**

- [ ] Create `src/services/apns.ts`:
  ```typescript
  import { SignJWT } from 'jose';

  export async function sendPushNotification(
    userId: string,
    notification: { title: string; body: string; data?: any },
    env: Env
  ) {
    const supabase = getSupabaseAdminClient(env);

    // Get user's push token
    const { data: user } = await supabase
      .from('users')
      .select('push_token')
      .eq('id', userId)
      .single();

    if (!user?.push_token) return;

    // Generate JWT for APNS
    const token = await new SignJWT({})
      .setProtectedHeader({ alg: 'ES256', kid: env.APNS_KEY_ID })
      .setIssuedAt()
      .setIssuer(env.APNS_TEAM_ID)
      .sign(privateKeyFromPEM(env.APNS_KEY));

    const payload = {
      aps: {
        alert: {
          title: notification.title,
          body: notification.body,
        },
        sound: 'default',
        badge: 1,
      },
      data: notification.data,
    };

    // Send to APNS (production)
    await fetch(`https://api.push.apple.com/3/device/${user.push_token}`, {
      method: 'POST',
      headers: {
        'authorization': `bearer ${token}`,
        'apns-topic': 'com.pakkt.ios',
        'apns-push-type': 'alert',
        'apns-priority': '10',
      },
      body: JSON.stringify(payload),
    });
  }
  ```

- [ ] Create route for sending notifications (admin/system only)

---

### **J. Image Upload (Cloudflare R2)**

- [ ] Create `src/services/imageUpload.ts`:
  ```typescript
  export async function uploadImage(
    file: File,
    folder: string,
    env: Env
  ): Promise<string> {
    const fileName = `${folder}/${crypto.randomUUID()}.jpg`;

    await env.IMAGES.put(fileName, file, {
      httpMetadata: {
        contentType: 'image/jpeg',
      },
    });

    // Return public URL
    return `https://images.pakkt.app/${fileName}`;
  }
  ```

**POST `/upload/avatar`**
```typescript
app.post('/avatar', requireAuth, async (c) => {
  const userId = c.get('userId');
  const formData = await c.req.formData();
  const file = formData.get('file') as File;

  if (!file) {
    return c.json({ error: 'No file provided' }, 400);
  }

  // Validate: max 2MB, jpg/png only
  if (file.size > 2 * 1024 * 1024) {
    return c.json({ error: 'File too large (max 2MB)' }, 400);
  }

  const url = await uploadImage(file, `avatars/${userId}`, c.env);
  return c.json({ url });
});
```

**POST `/upload/checkin`**
```typescript
// Similar to avatar, but for check-in photos (max 5MB)
```

---

## 🔧 UTILITIES & HELPERS

### **A. Error Handling**

- [ ] Create `src/middleware/errorHandler.ts`:
  ```typescript
  export function errorHandler(err: Error, c: Context) {
    console.error(err);

    if (err.name === 'ZodError') {
      return c.json({ error: 'Validation failed', details: err.issues }, 400);
    }

    if (err.message.includes('unique constraint')) {
      return c.json({ error: 'Resource already exists' }, 409);
    }

    return c.json({ error: 'Internal server error' }, 500);
  }
  ```

### **B. JWT Utilities**

- [ ] Create `src/lib/jwt.ts`:
  ```typescript
  import { SignJWT, jwtVerify } from 'jose';

  export async function signToken(payload: any, secret: string) {
    const encoder = new TextEncoder();
    return await new SignJWT(payload)
      .setProtectedHeader({ alg: 'HS256' })
      .setExpirationTime('30d')
      .sign(encoder.encode(secret));
  }

  export async function verifyToken(token: string, secret: string) {
    const encoder = new TextEncoder();
    const { payload } = await jwtVerify(token, encoder.encode(secret));
    return payload;
  }
  ```

### **C. Helper Functions**

- [ ] `generateInviteCode()` - Random 6-char code
- [ ] `calculateStreak()` - Streak logic based on consecutive check-ins
- [ ] `isWithinCheckInWindow()` - Check if current time is within 30-min window
- [ ] `parseTime()` - Parse "HH:MM" string to Date object
- [ ] `calculateBreakFine()` - Get 2x goal fine amount

---

## 🚀 DEPLOYMENT

### **A. Local Development**

- [ ] Start dev server: `wrangler dev`
- [ ] Test all endpoints with Postman/Insomnia
- [ ] Verify database connections
- [ ] Test real-time subscriptions

### **B. Production Deployment**

- [ ] Deploy to Cloudflare: `wrangler deploy`
- [ ] Verify custom domain: `api.pakkt.app`
- [ ] Set all secrets (production values)
- [ ] Monitor logs: `wrangler tail`
- [ ] Set up Sentry error tracking
- [ ] Configure rate limiting
- [ ] Enable CORS for `pakkt.app` domain

### **C. CI/CD (GitHub Actions)**

- [ ] Create `.github/workflows/deploy.yml`:
  ```yaml
  name: Deploy to Cloudflare Workers
  on:
    push:
      branches: [main]
  jobs:
    deploy:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v3
        - uses: actions/setup-node@v3
        - run: npm ci
        - run: npm run build
        - run: wrangler deploy
          env:
            CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
  ```

---

## 📊 MONITORING & ANALYTICS

- [ ] Set up Cloudflare Analytics (built-in)
- [ ] Monitor request count, latency, errors
- [ ] Set up alerts for:
  - Error rate >1%
  - Latency >500ms (p95)
  - 5xx responses
- [ ] Log all errors to Sentry
- [ ] Track API usage per endpoint

---

## ✅ PRE-LAUNCH CHECKLIST

- [ ] All endpoints tested and working
- [ ] Authentication flow complete
- [ ] Rate limiting active
- [ ] CORS configured correctly
- [ ] All secrets set in production
- [ ] Push notifications working end-to-end
- [ ] Image upload working (R2)
- [ ] Error handling comprehensive
- [ ] Logging and monitoring active
- [ ] Database RLS policies enforced
- [ ] Performance <200ms (p95)
- [ ] Load testing complete (1000 req/s)

---

**Next Steps:**
1. Set up Cloudflare account and Wrangler CLI
2. Initialize project structure
3. Implement authentication routes first
4. Test with Supabase integration
5. Build out remaining routes systematically
