# PAKKT - MASTER PROJECT ROADMAP

> **Mission:** Build the most aggressive social accountability app where friend groups hold each other accountable through real consequences.

---

## 🎯 PHASES OVERVIEW

### **PHASE 0: Foundation & Planning** (Weeks 1-2)
**Goal:** Solid technical foundation, design system, project setup

- [ ] Complete all planning documents and todo lists
- [ ] Set up development environment
- [ ] Configure backend infrastructure (Cloudflare + Supabase)
- [ ] Create design system in Figma
- [ ] Establish CI/CD pipeline
- [ ] Set up project management (GitHub Projects)

**Milestone:** Development environment ready, designs approved

---

### **PHASE 1: Core MVP** (Weeks 3-8)
**Goal:** Launch-ready app with core features - packs, goals, check-ins, basic fines

#### Sprint 1: Authentication & Onboarding (Week 3-4)
- [ ] Supabase Auth integration
- [ ] Onboarding flow (5 screens max)
- [ ] User profile creation
- [ ] Phone number verification
- [ ] Push notification permissions

**Milestone:** User can sign up and complete onboarding

#### Sprint 2: Packs & Social Core (Week 5-6)
- [ ] Create/join pack flow
- [ ] Pack member management
- [ ] Pack settings and rules
- [ ] Invite system (deep links)
- [ ] Real-time pack feed (basic)

**Milestone:** Users can form packs and see activity

#### Sprint 3: Goals & Check-Ins (Week 7-8)
- [ ] Goal creation interface
- [ ] Daily check-in flow with timer
- [ ] Photo upload for check-ins
- [ ] Streak tracking system
- [ ] Check-in notifications

**Milestone:** Users can create goals and check in daily

---

### **PHASE 2: Consequences System** (Weeks 9-12)
**Goal:** Real accountability through fines and phone jail

#### Sprint 4: Fine System (Week 9-10)
- [ ] Democratic voting for fines
- [ ] Fine amount configuration per pack
- [ ] Fine notification and timer
- [ ] Honor system payment tracking
- [ ] Fine history and stats

**Milestone:** Packs can vote on and track fines

#### Sprint 5: Phone Jail MVP (Week 11-12)
- [ ] iOS Screen Time API entitlement request
- [ ] Family Controls framework integration
- [ ] App blocking interface
- [ ] Jail timer with pause detection
- [ ] "Break jail" 2x fine option
- [ ] Jail notification system

**Milestone:** Phone jail works and blocks apps

---

### **PHASE 3: Social & Engagement** (Weeks 13-16)
**Goal:** Make it addictive and viral

#### Sprint 6: Feed & Interactions (Week 13-14)
- [ ] BeReal-style main feed
- [ ] React system (emoji reactions)
- [ ] Comments on check-ins
- [ ] Trash talk interface
- [ ] Streak celebrations
- [ ] Activity notifications

**Milestone:** Engaging social feed with interactions

#### Sprint 7: Gamification & Stats (Week 15-16)
- [ ] Personal stats dashboard
- [ ] Pack leaderboards
- [ ] Achievement system
- [ ] Streak milestones
- [ ] Share to Instagram Stories
- [ ] Screenshot generator for jail/fines

**Milestone:** Users want to share their wins/losses

---

### **PHASE 4: Payments & Monetization** (Weeks 17-20)
**Goal:** Convert to paying users, real money fines

#### Sprint 8: Subscription System (Week 17-18)
- [ ] RevenueCat integration
- [ ] Paywall design (aggressive, clear value)
- [ ] 3-day free trial flow
- [ ] Annual ($49) + Weekly ($4) plans
- [ ] Restore purchases
- [ ] Subscription status throughout app

**Milestone:** Users can subscribe and access premium features

#### Sprint 9: Real Money Fines (Week 19-20)
- [ ] Stripe Connect integration
- [ ] Venmo/Cash App linking
- [ ] Automatic fine collection
- [ ] Pack pool management
- [ ] Payout system
- [ ] Transaction history

**Milestone:** Real money flows through fines

---

### **PHASE 5: Polish & Launch Prep** (Weeks 21-24)
**Goal:** App Store ready, marketing assets, beta testing

#### Sprint 10: App Store Prep (Week 21-22)
- [ ] App Store screenshots (8 required)
- [ ] App preview video
- [ ] App Store description copy
- [ ] Privacy policy
- [ ] Terms of service
- [ ] Support page
- [ ] Age rating justification
- [ ] Screen Time API justification document

**Milestone:** App Store listing ready

#### Sprint 11: Beta Testing (Week 23)
- [ ] TestFlight setup
- [ ] Recruit 50-100 beta testers (target demo)
- [ ] Bug tracking system
- [ ] Feedback collection
- [ ] Performance monitoring
- [ ] Crash reporting (Sentry)

**Milestone:** Beta with real users, major bugs fixed

#### Sprint 12: Marketing Launch Prep (Week 24)
- [ ] Landing page (pakkt.app)
- [ ] Instagram account (@pakkt.app)
- [ ] TikTok account (@pakkt.app)
- [ ] Press kit
- [ ] Campus ambassador recruitment
- [ ] Influencer outreach list
- [ ] Launch day content calendar

**Milestone:** Marketing machine ready to go

---

### **PHASE 6: LAUNCH** (Week 25)
**Goal:** App Store approval, public launch, initial traction

- [ ] Submit to App Store
- [ ] App Store approval received
- [ ] Public launch announcement
- [ ] Campus flyering blitz (3-5 schools)
- [ ] Influencer seeding (10-20 accounts)
- [ ] Product Hunt launch
- [ ] Press outreach
- [ ] Monitor metrics daily

**Success Metrics:**
- 1,000 downloads in Week 1
- 100 active packs formed
- 50+ subscriptions
- 8+ app opens per day (engaged users)

---

### **PHASE 7: Growth & Iteration** (Months 2-6)
**Goal:** Hit 50K users, optimize retention, viral growth

#### Month 2-3: Campus Expansion
- [ ] Expand to 10 more campuses
- [ ] Campus challenge events
- [ ] Greek life partnerships
- [ ] Athletic team pilots
- [ ] Referral program launch

#### Month 4-6: Viral Mechanics
- [ ] Instagram Stories integration
- [ ] TikTok sharing templates
- [ ] Weekly pack challenges
- [ ] Cross-pack competitions
- [ ] Ambassador program scaling

**Target Metrics:**
- 50,000 users
- 10,000 active packs
- $500K subscription revenue
- 40% D7 retention
- 8+ app opens/day

---

## 🚨 CRITICAL PATH ITEMS

These MUST be completed for launch:

1. **iOS Screen Time API Approval** - Start Week 1, can take 2-4 weeks
2. **App Store Review** - Plan for 2-3 submissions, rejections likely
3. **Stripe Account Approval** - Apply early, can take 1-2 weeks
4. **Legal Documents** - Privacy policy, TOS (required for App Store)
5. **Beta Testing** - Need real user feedback before launch
6. **Payment Processing** - Must work flawlessly for subscription

---

## 📊 KEY METRICS TO TRACK

**Development Phase:**
- Sprint velocity (features completed per week)
- Bug count and resolution time
- Code coverage (target: 70%+)
- Build time and crash rate

**Post-Launch:**
- **North Star:** Weekly Active Packs (packs with 2+ members, 3+ check-ins/week)
- DAU / MAU ratio (target: 40%+)
- Subscription conversion rate (target: 10%+)
- D1, D7, D30 retention
- Average revenue per user (ARPU)
- K-factor (viral coefficient, target: >1.2)
- App opens per day (target: 8+)

---

## 🎨 DESIGN PRINCIPLES (Enforce Throughout)

- **Dark Neobrutalism + Liquid Glass** - Pure black, neon accents, glass cards
- **Aggressive, not gentle** - No soft language, no pastels
- **Shareable moments** - Every feature creates content
- **Real consequences** - No fake accountability
- **Pack-first** - Social over solo

---

## 🛠️ TECH STACK LOCKED IN

**iOS App:**
- Swift + SwiftUI
- Family Controls API (phone jail)
- Screen Time API
- Combine for reactive programming
- Swift Concurrency (async/await)

**Backend:**
- Cloudflare Workers (API, edge functions)
- Supabase (PostgreSQL, real-time, auth, storage)
- Cloudflare R2 (image storage)

**Payments:**
- RevenueCat (subscriptions)
- Stripe (fine processing)

**Analytics:**
- PostHog (product analytics)
- Sentry (crash reporting)

---

## 📱 LAUNCH TARGETS

**Primary:**
- 5 major state schools (Ohio State, Michigan, Penn State, Arizona State, Texas)
- Gym rats, Greek life, athlete friend groups
- Ages 18-24, primarily male

**App Store Categories:**
- Primary: Productivity
- Secondary: Social Networking

**Age Rating:** 12+ (with parent controls for minors)

---

## 💰 SUCCESS = REVENUE

**Week 1:** $500 (50 subs × $4/week + 50 trials)
**Month 1:** $5,000 (100 annual @ $49, 500 weekly @ $4)
**Month 6:** $50,000 (5,000 paying users, 60% annual)
**Year 1:** $500,000 (10,000 paying users)

---

## 🔥 LAUNCH READINESS CHECKLIST

Before public launch, ALL must be ✅:

- [ ] App Store approved and live
- [ ] Subscriptions processing correctly
- [ ] Phone jail works reliably
- [ ] No critical bugs in core flow
- [ ] Push notifications working
- [ ] Real-time feed stable
- [ ] Privacy policy + TOS published
- [ ] Support email responding within 24hrs
- [ ] Landing page live
- [ ] Social accounts active
- [ ] Campus ambassadors recruited (10+)
- [ ] Influencers seeded (5+)
- [ ] Analytics tracking all events
- [ ] Crash reporting configured
- [ ] Payment processing tested (real money)

---

**Next Steps:**
1. Review all detailed todo lists in this folder
2. Set up GitHub Projects with these phases
3. Begin Phase 0 immediately
4. Track everything obsessively