# PAKKT - TECHNICAL ARCHITECTURE TODO

> **Goal:** Build a scalable, real-time, reliable technical foundation for social accountability

---

## 🏗️ ARCHITECTURE OVERVIEW

```
┌─────────────────────────────────────────────────────────────┐
│                       iOS APP (Swift)                        │
│  SwiftUI • Family Controls • Screen Time • Combine           │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      │ REST + WebSocket
                      │
┌─────────────────────▼───────────────────────────────────────┐
│              CLOUDFLARE WORKERS (Edge API)                   │
│  Authentication • Business Logic • Rate Limiting             │
└─────────────────────┬───────────────────────────────────────┘
                      │
        ┌─────────────┴─────────────┬──────────────────┐
        │                           │                   │
┌───────▼────────┐      ┌──────────▼─────┐   ┌────────▼──────┐
│   SUPABASE     │      │ CLOUDFLARE R2  │   │  STRIPE API   │
│  PostgreSQL    │      │ Image Storage  │   │   Payments    │
│  Real-time     │      └────────────────┘   └───────────────┘
│  Auth          │
└────────────────┘
```

---

## 📋 PHASE 0: INFRASTRUCTURE SETUP

### **A. Development Environment**

- [ ] Install Xcode 15+ (latest stable)
- [ ] Install Homebrew (package manager)
- [ ] Install Swift CLI tools
- [ ] Install Node.js 20+ LTS (for Cloudflare Workers)
- [ ] Install Wrangler CLI (`npm install -g wrangler`)
- [ ] Install Supabase CLI (`brew install supabase/tap/supabase`)
- [ ] Install CocoaPods / Swift Package Manager
- [ ] Set up Git configuration
- [ ] Configure SSH keys for GitHub
- [ ] Install SwiftLint for code quality

**Verification:**
```bash
xcodebuild -version
swift --version
node --version
wrangler --version
supabase --version
```

---

### **B. Project Initialization**

- [ ] Create Xcode project: "Pakkt" (iOS 17+ minimum)
- [ ] Configure app identifier: `com.pakkt.ios`
- [ ] Set up project structure:
  ```
  Pakkt/
  ├── App/
  ├── Features/
  │   ├── Auth/
  │   ├── Onboarding/
  │   ├── Packs/
  │   ├── Goals/
  │   ├── CheckIns/
  │   ├── Fines/
  │   ├── PhoneJail/
  │   └── Social/
  ├── Core/
  │   ├── Networking/
  │   ├── Database/
  │   ├── Models/
  │   └── Extensions/
  ├── DesignSystem/
  │   ├── Colors/
  │   ├── Typography/
  │   ├── Components/
  │   └── Themes/
  └── Resources/
  ```

- [ ] Add `.gitignore` for Swift/Xcode
- [ ] Create `README.md` with setup instructions
- [ ] Initialize Git repository
- [ ] Create GitHub repository: `pakkt-ios`
- [ ] Set up branch protection rules (main branch)

---

### **C. Backend Infrastructure - Supabase**

#### 1. Supabase Project Setup
- [ ] Create Supabase project: "pakkt-production"
- [ ] Note Project URL and anon key
- [ ] Create Supabase project: "pakkt-development"
- [ ] Configure environment variables in Xcode

#### 2. Database Schema Design

**Tables to Create:**

- [ ] **users** table:
  ```sql
  CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    phone_number TEXT UNIQUE NOT NULL,
    username TEXT UNIQUE NOT NULL,
    display_name TEXT NOT NULL,
    avatar_url TEXT,
    bio TEXT,
    total_fines_paid DECIMAL DEFAULT 0,
    total_fines_received DECIMAL DEFAULT 0,
    current_streak INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    total_check_ins INT DEFAULT 0,
    total_jails INT DEFAULT 0,
    subscription_status TEXT DEFAULT 'inactive',
    subscription_plan TEXT,
    subscription_expires_at TIMESTAMPTZ,
    push_token TEXT,
    is_active BOOLEAN DEFAULT true,
    last_seen_at TIMESTAMPTZ DEFAULT NOW()
  );
  ```

- [ ] **packs** table:
  ```sql
  CREATE TABLE packs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    name TEXT NOT NULL,
    description TEXT,
    avatar_url TEXT,
    created_by UUID REFERENCES users(id),
    default_fine_amount DECIMAL DEFAULT 5.00,
    default_jail_duration INT DEFAULT 30,
    min_votes_for_fine INT DEFAULT 2,
    is_active BOOLEAN DEFAULT true,
    total_fines_collected DECIMAL DEFAULT 0,
    pack_pool_balance DECIMAL DEFAULT 0,
    invite_code TEXT UNIQUE NOT NULL,
    member_limit INT DEFAULT 10
  );
  ```

- [ ] **pack_members** table:
  ```sql
  CREATE TABLE pack_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pack_id UUID REFERENCES packs(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    role TEXT DEFAULT 'member', -- member, admin
    is_active BOOLEAN DEFAULT true,
    total_check_ins INT DEFAULT 0,
    total_fines_paid DECIMAL DEFAULT 0,
    current_streak INT DEFAULT 0,
    UNIQUE(pack_id, user_id)
  );
  ```

- [ ] **goals** table:
  ```sql
  CREATE TABLE goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    pack_id UUID REFERENCES packs(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id),
    title TEXT NOT NULL,
    description TEXT,
    check_in_time TIME NOT NULL, -- Daily time (e.g., "06:00:00")
    fine_amount DECIMAL,
    jail_duration INT,
    requires_photo BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    start_date DATE DEFAULT CURRENT_DATE,
    end_date DATE
  );
  ```

- [ ] **check_ins** table:
  ```sql
  CREATE TABLE check_ins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    goal_id UUID REFERENCES goals(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id),
    pack_id UUID REFERENCES packs(id),
    check_in_date DATE DEFAULT CURRENT_DATE,
    check_in_time TIMESTAMPTZ DEFAULT NOW(),
    photo_url TEXT,
    caption TEXT,
    was_on_time BOOLEAN DEFAULT true,
    streak_count INT DEFAULT 0,
    UNIQUE(goal_id, user_id, check_in_date)
  );
  ```

- [ ] **fines** table:
  ```sql
  CREATE TABLE fines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    pack_id UUID REFERENCES packs(id),
    user_id UUID REFERENCES users(id),
    goal_id UUID REFERENCES goals(id),
    amount DECIMAL NOT NULL,
    reason TEXT NOT NULL,
    status TEXT DEFAULT 'pending', -- pending, paid, disputed, waived
    payment_method TEXT,
    paid_at TIMESTAMPTZ,
    votes_for INT DEFAULT 0,
    votes_against INT DEFAULT 0,
    voting_deadline TIMESTAMPTZ,
    stripe_payment_id TEXT
  );
  ```

- [ ] **fine_votes** table:
  ```sql
  CREATE TABLE fine_votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fine_id UUID REFERENCES fines(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id),
    vote BOOLEAN NOT NULL, -- true = for, false = against
    voted_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(fine_id, user_id)
  );
  ```

- [ ] **phone_jails** table:
  ```sql
  CREATE TABLE phone_jails (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    pack_id UUID REFERENCES packs(id),
    user_id UUID REFERENCES users(id),
    goal_id UUID REFERENCES goals(id),
    duration_minutes INT NOT NULL,
    blocked_apps TEXT[], -- Array of bundle IDs
    started_at TIMESTAMPTZ DEFAULT NOW(),
    scheduled_end_at TIMESTAMPTZ NOT NULL,
    actual_end_at TIMESTAMPTZ,
    break_fine_amount DECIMAL,
    was_broken BOOLEAN DEFAULT false,
    broken_at TIMESTAMPTZ,
    status TEXT DEFAULT 'active' -- active, completed, broken
  );
  ```

- [ ] **reactions** table:
  ```sql
  CREATE TABLE reactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    user_id UUID REFERENCES users(id),
    target_type TEXT NOT NULL, -- check_in, fine, jail
    target_id UUID NOT NULL,
    emoji TEXT NOT NULL, -- 💀, 🔥, 💪, 👑, etc.
    UNIQUE(user_id, target_type, target_id, emoji)
  );
  ```

- [ ] **comments** table:
  ```sql
  CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    user_id UUID REFERENCES users(id),
    target_type TEXT NOT NULL,
    target_id UUID NOT NULL,
    content TEXT NOT NULL,
    is_deleted BOOLEAN DEFAULT false
  );
  ```

- [ ] **notifications** table:
  ```sql
  CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    user_id UUID REFERENCES users(id),
    type TEXT NOT NULL, -- check_in_reminder, fine_voted, jail_started, etc.
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    data JSONB,
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMPTZ
  );
  ```

#### 3. Row Level Security (RLS) Policies

- [ ] Enable RLS on all tables
- [ ] Create policy: Users can read their own data
- [ ] Create policy: Users can read pack data they're members of
- [ ] Create policy: Only pack members can create check-ins
- [ ] Create policy: Only pack members can vote on fines
- [ ] Create policy: Users can update their own profile
- [ ] Test RLS policies with different user roles

#### 4. Database Functions & Triggers

- [ ] Function: `update_user_streak()` - Auto-calculate streaks
- [ ] Function: `calculate_pack_stats()` - Aggregate pack statistics
- [ ] Function: `send_check_in_notification()` - Trigger push notifications
- [ ] Trigger: Update `users.last_seen_at` on any user action
- [ ] Trigger: Increment `total_check_ins` on new check-in
- [ ] Trigger: Calculate fine votes and auto-activate if threshold met
- [ ] Function: `generate_invite_code()` - Create unique pack invite codes

#### 5. Indexes for Performance

- [ ] Index on `users.phone_number` (unique, for auth)
- [ ] Index on `users.username` (unique, for search)
- [ ] Index on `pack_members(pack_id, user_id)` (composite)
- [ ] Index on `check_ins(user_id, check_in_date)` (for streaks)
- [ ] Index on `goals(pack_id, is_active)` (for active goals)
- [ ] Index on `fines(user_id, status)` (for pending fines)
- [ ] Index on `notifications(user_id, is_read, created_at)` (for feed)

#### 6. Supabase Real-time Configuration

- [ ] Enable real-time on `check_ins` table (for live feed)
- [ ] Enable real-time on `reactions` table
- [ ] Enable real-time on `comments` table
- [ ] Enable real-time on `phone_jails` table (for jail timer sync)
- [ ] Configure real-time broadcast for pack feeds
- [ ] Test WebSocket connections from iOS

#### 7. Supabase Storage Buckets

- [ ] Create bucket: `avatars` (public, 2MB limit, jpg/png only)
- [ ] Create bucket: `check-in-photos` (private, 5MB limit, jpg/png/heic)
- [ ] Configure RLS for storage: Users can upload to their own folders
- [ ] Set up automatic image optimization (resize to 1024px max)
- [ ] Configure CDN caching headers

---

### **D. Backend Infrastructure - Cloudflare Workers**

#### 1. Cloudflare Account Setup
- [ ] Create Cloudflare account
- [ ] Add custom domain: `api.pakkt.app`
- [ ] Configure DNS records
- [ ] Generate API tokens for Wrangler

#### 2. Workers Project Setup
- [ ] Initialize Wrangler project: `wrangler init pakkt-api`
- [ ] Configure `wrangler.toml`:
  ```toml
  name = "pakkt-api"
  main = "src/index.ts"
  compatibility_date = "2024-01-01"

  [env.production]
  route = "api.pakkt.app/*"

  [env.development]
  ```

- [ ] Set up TypeScript configuration
- [ ] Create project structure:
  ```
  workers/
  ├── src/
  │   ├── index.ts
  │   ├── routes/
  │   │   ├── auth.ts
  │   │   ├── packs.ts
  │   │   ├── goals.ts
  │   │   ├── check-ins.ts
  │   │   ├── fines.ts
  │   │   └── notifications.ts
  │   ├── middleware/
  │   │   ├── auth.ts
  │   │   ├── rateLimit.ts
  │   │   └── validation.ts
  │   ├── services/
  │   │   ├── supabase.ts
  │   │   ├── stripe.ts
  │   │   └── push.ts
  │   └── utils/
  ├── test/
  └── wrangler.toml
  ```

#### 3. API Endpoints to Build

- [ ] `POST /auth/login` - Phone number authentication
- [ ] `POST /auth/verify` - OTP verification
- [ ] `GET /auth/me` - Get current user
- [ ] `POST /packs` - Create new pack
- [ ] `POST /packs/:id/join` - Join pack with invite code
- [ ] `GET /packs/:id` - Get pack details
- [ ] `GET /packs/:id/members` - List pack members
- [ ] `POST /goals` - Create goal
- [ ] `POST /check-ins` - Record check-in
- [ ] `GET /check-ins/feed` - Get pack feed
- [ ] `POST /fines` - Create fine
- [ ] `POST /fines/:id/vote` - Vote on fine
- [ ] `POST /phone-jail/start` - Start jail session
- [ ] `POST /phone-jail/:id/break` - Break jail (pay 2x)
- [ ] `POST /reactions` - Add reaction
- [ ] `POST /comments` - Add comment
- [ ] `POST /notifications/send` - Send push notification

#### 4. Middleware Implementation

- [ ] JWT authentication middleware
- [ ] Rate limiting (100 req/min per user)
- [ ] Request validation (Zod schemas)
- [ ] Error handling and logging
- [ ] CORS configuration
- [ ] Request logging to Cloudflare Analytics

#### 5. Environment Variables (Secrets)

- [ ] `SUPABASE_URL` - Supabase project URL
- [ ] `SUPABASE_SERVICE_KEY` - Service role key (bypass RLS)
- [ ] `SUPABASE_ANON_KEY` - Public anon key
- [ ] `STRIPE_SECRET_KEY` - Stripe secret key
- [ ] `STRIPE_WEBHOOK_SECRET` - Stripe webhook verification
- [ ] `JWT_SECRET` - For signing auth tokens
- [ ] `APNS_KEY` - Apple Push Notification key
- [ ] `APNS_KEY_ID` - APNS key identifier
- [ ] `APNS_TEAM_ID` - Apple Developer Team ID

Set via: `wrangler secret put <KEY_NAME>`

---

### **E. iOS App - Core Architecture**

#### 1. Dependency Management

- [ ] Create `Package.swift` for SPM dependencies
- [ ] Add Supabase Swift SDK
- [ ] Add Stripe iOS SDK
- [ ] Add Kingfisher (image loading)
- [ ] Add KeychainAccess (secure storage)
- [ ] Consider: SwiftLint, SwiftFormat for code quality

#### 2. App Architecture: MVVM + Repository Pattern

```
View (SwiftUI)
  ↓
ViewModel (ObservableObject)
  ↓
Repository (Protocol)
  ↓
API Service / Local Database
```

- [ ] Create `APIClient.swift` - HTTP client wrapper
- [ ] Create `SupabaseClient.swift` - Supabase initialization
- [ ] Create `AuthRepository.swift` - Auth operations
- [ ] Create `PackRepository.swift` - Pack CRUD
- [ ] Create `GoalRepository.swift` - Goal management
- [ ] Create `CheckInRepository.swift` - Check-in logic
- [ ] Create `FineRepository.swift` - Fine operations
- [ ] Create `PhoneJailRepository.swift` - Jail control

#### 3. Core Models

- [ ] `User.swift` - User model (Codable)
- [ ] `Pack.swift` - Pack model
- [ ] `PackMember.swift` - Pack member model
- [ ] `Goal.swift` - Goal model
- [ ] `CheckIn.swift` - Check-in model
- [ ] `Fine.swift` - Fine model
- [ ] `PhoneJail.swift` - Jail session model
- [ ] `Notification.swift` - Notification model
- [ ] `Reaction.swift` - Reaction model
- [ ] `Comment.swift` - Comment model

#### 4. ViewModels (ObservableObject)

- [ ] `AuthViewModel` - Login, signup, session management
- [ ] `OnboardingViewModel` - Onboarding flow state
- [ ] `PackListViewModel` - User's packs
- [ ] `PackDetailViewModel` - Single pack view
- [ ] `GoalListViewModel` - Goals in pack
- [ ] `CheckInViewModel` - Check-in flow
- [ ] `FeedViewModel` - Social feed (real-time)
- [ ] `PhoneJailViewModel` - Jail timer and control
- [ ] `ProfileViewModel` - User profile and stats
- [ ] `SubscriptionViewModel` - Paywall and purchases

#### 5. Networking Layer

- [ ] Create `Endpoint.swift` protocol
- [ ] Create `NetworkError.swift` enum
- [ ] Create `APIClient.swift` with async/await
- [ ] Implement request/response logging (debug builds)
- [ ] Add retry logic for failed requests
- [ ] Implement token refresh flow
- [ ] Handle 401 Unauthorized (logout user)

#### 6. Local Data Persistence

- [ ] UserDefaults wrapper for simple data
- [ ] Keychain wrapper for sensitive data (tokens, keys)
- [ ] Consider: Core Data or Realm for offline support (Phase 2)
- [ ] Cache user profile locally
- [ ] Cache pack list and member data
- [ ] Implement cache invalidation strategy

#### 7. Real-time Subscriptions (Supabase)

- [ ] Connect to Supabase Realtime WebSocket
- [ ] Subscribe to pack feed updates
- [ ] Subscribe to fine votes in real-time
- [ ] Subscribe to jail status updates
- [ ] Subscribe to reactions and comments
- [ ] Handle connection drops and reconnection

---

### **F. iOS Capabilities & Entitlements**

#### 1. Screen Time & Family Controls

**CRITICAL PATH - Start Week 1**

- [ ] Read Apple's Screen Time API documentation thoroughly
- [ ] Request Family Controls entitlement from Apple:
  - Go to: https://developer.apple.com/contact/request/family-controls-distribution
  - Provide detailed justification (accountability, not parental control)
  - Mention similar apps: Opal, Freedom, one sec
  - Explain democratic voting mechanism for jail activation

- [ ] Add `Family Controls` capability in Xcode
- [ ] Add entitlement to App ID in Apple Developer Portal
- [ ] Import `FamilyControls` framework
- [ ] Request authorization: `AuthorizationCenter.shared.requestAuthorization()`
- [ ] Test on physical device (Simulator won't work)

**Expected Timeline:** 2-4 weeks for Apple approval

#### 2. Push Notifications (APNS)

- [ ] Enable Push Notifications capability in Xcode
- [ ] Create APNS key in Apple Developer Portal
- [ ] Download `.p8` key file (keep secure!)
- [ ] Configure APNS in Supabase project settings
- [ ] Request notification permission on app launch
- [ ] Implement `UNUserNotificationCenterDelegate`
- [ ] Handle notification taps (deep linking)
- [ ] Test local notifications first
- [ ] Test remote notifications (production APNS)

#### 3. App Store Capabilities

- [ ] Enable In-App Purchases capability
- [ ] Configure App Groups (for WidgetKit later)
- [ ] Add Background Modes: `remote-notification`
- [ ] Add Background Modes: `processing` (for check-in reminders)
- [ ] Configure Associated Domains (for universal links)

---

### **G. Payment Infrastructure**

#### 1. Stripe Setup

- [ ] Create Stripe account
- [ ] Activate account (provide business info)
- [ ] Create product: "Pakkt Weekly" - $4/week
- [ ] Create product: "Pakkt Annual" - $49/year
- [ ] Note Price IDs for both products
- [ ] Set up webhook endpoint: `https://api.pakkt.app/webhooks/stripe`
- [ ] Configure webhook events:
  - `payment_intent.succeeded`
  - `payment_intent.failed`
  - `charge.refunded`
- [ ] Test with Stripe test mode API keys

#### 2. RevenueCat Setup (for Subscriptions)

- [ ] Create RevenueCat account
- [ ] Create project: "Pakkt"
- [ ] Configure iOS app (bundle ID: `com.pakkt.ios`)
- [ ] Add App Store Connect API key
- [ ] Create Entitlements: `pro_features`
- [ ] Create Offerings:
  - Weekly: $4/week
  - Annual: $49/year (default, recommended)
- [ ] Configure 3-day free trial on Annual plan
- [ ] Set up webhook to sync with Supabase
- [ ] Install RevenueCat SDK in iOS app
- [ ] Test purchases in sandbox environment

#### 3. App Store Connect In-App Purchases

- [ ] Create IAP: "Pakkt Weekly Subscription"
  - Type: Auto-renewable subscription
  - Product ID: `com.pakkt.weekly`
  - Price: $3.99/week
  - Subscription Group: "Pakkt Pro"

- [ ] Create IAP: "Pakkt Annual Subscription"
  - Type: Auto-renewable subscription
  - Product ID: `com.pakkt.annual`
  - Price: $49.99/year
  - Free Trial: 3 days
  - Subscription Group: "Pakkt Pro"

- [ ] Add subscription descriptions and benefits
- [ ] Create promotional images for paywall
- [ ] Set up subscription management URL
- [ ] Configure App Store server notifications

---

### **H. Development Tools & Monitoring**

#### 1. Analytics & Monitoring

- [ ] Set up PostHog account (product analytics)
- [ ] Install PostHog SDK in iOS app
- [ ] Define key events to track:
  - `app_opened`
  - `user_signed_up`
  - `pack_created`
  - `pack_joined`
  - `goal_created`
  - `check_in_completed`
  - `fine_activated`
  - `jail_started`
  - `jail_broken`
  - `subscription_started`
  - `paywall_viewed`
- [ ] Set up funnels (signup → pack join → first check-in)
- [ ] Configure retention cohorts

#### 2. Error Tracking

- [ ] Set up Sentry account
- [ ] Install Sentry SDK for iOS
- [ ] Install Sentry for Cloudflare Workers
- [ ] Configure error sampling (100% in dev, 20% in prod)
- [ ] Set up alerts for critical errors
- [ ] Integrate with Slack for real-time error notifications

#### 3. CI/CD Pipeline

- [ ] Set up GitHub Actions workflow
- [ ] Automate: SwiftLint on every PR
- [ ] Automate: Unit tests on every commit
- [ ] Automate: Build and archive for TestFlight
- [ ] Automate: Deploy Workers on merge to `main`
- [ ] Set up Fastlane for iOS deployments
- [ ] Configure automatic TestFlight uploads

#### 4. Version Control & Branching

- [ ] Branching strategy: Git Flow
  - `main` - production
  - `develop` - active development
  - `feature/*` - new features
  - `hotfix/*` - urgent fixes

- [ ] Protect `main` branch (require PR reviews)
- [ ] Set up PR templates with checklist
- [ ] Configure commit message linting
- [ ] Tag releases: `v1.0.0`, `v1.1.0`, etc.

---

### **I. Testing Infrastructure**

#### 1. Unit Tests

- [ ] Set up XCTest framework
- [ ] Write tests for ViewModels (business logic)
- [ ] Write tests for Repositories (mocked)
- [ ] Write tests for API Client
- [ ] Target: 70%+ code coverage on core logic
- [ ] Run tests in CI pipeline

#### 2. UI Tests

- [ ] Set up XCUITest framework
- [ ] Test critical flows:
  - Sign up → onboarding → pack creation
  - Check-in flow (happy path)
  - Fine voting flow
  - Phone jail activation
- [ ] Test on multiple device sizes (iPhone 14, 14 Pro Max, SE)

#### 3. Integration Tests

- [ ] Test Supabase connection and queries
- [ ] Test real-time subscriptions
- [ ] Test push notification delivery
- [ ] Test Stripe payment flow (sandbox)
- [ ] Test Family Controls authorization flow

---

### **J. Security & Compliance**

#### 1. Data Security

- [ ] All API calls over HTTPS only
- [ ] Implement certificate pinning (optional, for Phase 2)
- [ ] Encrypt sensitive local data (Keychain)
- [ ] Never log sensitive data (passwords, tokens, payment info)
- [ ] Implement data retention policy (delete old data after 2 years)
- [ ] Add user data export feature (GDPR compliance)
- [ ] Add account deletion feature (fully delete all user data)

#### 2. Privacy Policy & Legal

- [ ] Draft Privacy Policy (required for App Store)
  - What data we collect (phone, photos, usage)
  - How we use it (accountability, social features)
  - Third-party services (Supabase, Stripe, APNS)
  - Data retention and deletion
  - COPPA compliance (ages 13+)

- [ ] Draft Terms of Service
  - User responsibilities
  - Fine payment terms
  - Phone jail disclaimer
  - Account termination conditions
  - Dispute resolution

- [ ] Create EULA (End User License Agreement)
- [ ] Host legal docs at `pakkt.app/privacy` and `pakkt.app/terms`
- [ ] Link in app settings and App Store listing

#### 3. Age Restrictions & Parental Controls

- [ ] Set App Store age rating: 12+
- [ ] Implement age verification on signup
- [ ] If user under 18:
  - Require parent email for approval
  - Send parent notification email
  - Limit fine amounts ($5 max)
  - Limit jail duration (30 min max)
  - Parent can view activity (read-only)
- [ ] Add parent dashboard (Phase 2)

---

### **K. Documentation**

- [ ] Write API documentation (OpenAPI/Swagger)
- [ ] Document database schema (ER diagram)
- [ ] Write setup guide for developers
- [ ] Document environment variables and secrets
- [ ] Create architecture decision records (ADRs)
- [ ] Write deployment guide
- [ ] Create troubleshooting guide

---

### **L. Pre-Launch Infrastructure Checklist**

Before going live, verify ALL of these:

- [ ] Supabase production database backed up daily
- [ ] All secrets rotated from development values
- [ ] Rate limiting enabled on all API endpoints
- [ ] Error monitoring active (Sentry)
- [ ] Analytics tracking all key events (PostHog)
- [ ] Push notifications working end-to-end
- [ ] Payment processing works with real money (small test)
- [ ] Family Controls entitlement approved and working
- [ ] SSL certificates valid for `api.pakkt.app`
- [ ] Database indexes created for performance
- [ ] RLS policies tested thoroughly
- [ ] All API endpoints return proper error codes
- [ ] CORS configured correctly
- [ ] Webhook endpoints secured (verify signatures)
- [ ] Privacy Policy and TOS published
- [ ] Support email configured: `support@pakkt.app`
- [ ] Incident response plan documented

---

## 🎯 SUCCESS METRICS

**Infrastructure Quality:**
- API response time <200ms (p95)
- Database query time <50ms (p95)
- Uptime: 99.9%+
- Zero data loss
- Real-time latency <500ms

**Security:**
- Zero data breaches
- All secrets stored securely
- Regular security audits
- HTTPS everywhere

**Monitoring:**
- Error rate <0.1%
- Crash rate <0.5%
- All critical alerts routing to on-call

---

**Next Steps:**
1. Start with Supabase project setup
2. Request Family Controls entitlement IMMEDIATELY
3. Set up local development environment
4. Begin database schema implementation
