# PAKKT - TESTING & QA TODO

> **Goal:** Ship a rock-solid app with <0.5% crash rate and excellent user experience

---

## 🎯 TESTING PHILOSOPHY

**Quality Standards:**
- Zero critical bugs in core flows (auth, check-in, fines, jail)
- <0.5% crash rate
- <100ms UI response time
- 70%+ code coverage on business logic
- All edge cases handled gracefully

**Testing Pyramid:**
```
           E2E Tests (10%)
        ┌──────────────┐
        │  UI Tests    │
     ┌──┴──────────────┴──┐
     │  Integration Tests  │
  ┌──┴─────────────────────┴──┐
  │      Unit Tests (60%)      │
  └────────────────────────────┘
```

---

## 📋 PHASE 1: UNIT TESTING

### **A. Setup**

- [ ] Configure XCTest framework in Xcode
- [ ] Create `PakktTests` target
- [ ] Install testing dependencies:
  - [ ] Quick/Nimble (BDD-style testing, optional)
  - [ ] OHHTTPStubs (mock network calls)

- [ ] Set up CI to run tests on every commit
- [ ] Configure code coverage reporting (Xcode → Test Plan → Code Coverage)

---

### **B. ViewModel Tests**

Test all business logic in ViewModels:

#### 1. AuthViewModel Tests

- [ ] Test: `sendOTP()` calls API correctly
- [ ] Test: `sendOTP()` handles invalid phone number
- [ ] Test: `sendOTP()` handles rate limit error (429)
- [ ] Test: `verifyOTP()` stores JWT in Keychain on success
- [ ] Test: `verifyOTP()` shows error for invalid code
- [ ] Test: `logout()` clears stored credentials
- [ ] Test: `isAuthenticated` updates correctly

#### 2. CheckInViewModel Tests

- [ ] Test: Timer countdown calculates correctly (30 min window)
- [ ] Test: `isWithinCheckInWindow()` returns true/false correctly
- [ ] Test: `submitCheckIn()` uploads photo to R2
- [ ] Test: `submitCheckIn()` creates check-in in database
- [ ] Test: Late check-in triggers fine creation
- [ ] Test: Streak calculation works (consecutive days)
- [ ] Test: Streak breaks on missed day
- [ ] Test: Photo upload retries on failure (3 attempts)

#### 3. FineViewModel Tests

- [ ] Test: `voteOnFine()` records vote correctly
- [ ] Test: Fine activates when threshold met (e.g., 2/3 votes)
- [ ] Test: User cannot vote on their own fine
- [ ] Test: User cannot vote twice on same fine
- [ ] Test: `payFine()` updates status to 'paid'
- [ ] Test: Fine amount updates user's total fines paid

#### 4. PhoneJailViewModel Tests

- [ ] Test: `startJail()` calculates correct end time
- [ ] Test: Timer pauses when app backgrounds
- [ ] Test: Timer resumes when app foregrounds
- [ ] Test: `breakJail()` creates 2x fine
- [ ] Test: Jail completes when timer reaches zero
- [ ] Test: Jail status syncs with backend

#### 5. PackViewModel Tests

- [ ] Test: `createPack()` generates unique invite code
- [ ] Test: `joinPack()` validates invite code
- [ ] Test: Cannot join full pack (member limit reached)
- [ ] Test: Cannot join same pack twice
- [ ] Test: Pack admin can remove members
- [ ] Test: Non-admin cannot remove members

---

### **C. Repository Tests**

Test data layer with mocked API:

- [ ] Test: `AuthRepository.login()` calls correct endpoint
- [ ] Test: `CheckInRepository.submitCheckIn()` sends correct payload
- [ ] Test: `PackRepository.fetchPacks()` parses response correctly
- [ ] Test: Repository handles 401 Unauthorized (refreshes token)
- [ ] Test: Repository retries on network failure (3 attempts)
- [ ] Test: Repository caches responses (optional)

---

### **D. Model Tests**

Test Codable encoding/decoding:

- [ ] Test: `User` model decodes from JSON correctly
- [ ] Test: `Pack` model encodes to JSON correctly
- [ ] Test: `CheckIn` model handles optional fields (photo, caption)
- [ ] Test: `Fine` model calculates status based on votes
- [ ] Test: Date/time parsing works across timezones

---

### **E. Utility Tests**

Test helper functions:

- [ ] Test: JWT parsing extracts user ID correctly
- [ ] Test: Phone number formatting works (US and international)
- [ ] Test: Invite code generation is unique (1000 iterations)
- [ ] Test: Streak calculation edge cases (missed days, time zones)
- [ ] Test: Time window calculation (30 min before goal time)

---

## 🧪 PHASE 2: INTEGRATION TESTING

### **A. API Integration Tests**

Test real API calls (against staging environment):

- [ ] Test: Full auth flow (send OTP → verify → get user)
- [ ] Test: Create pack → Join pack → Fetch pack details
- [ ] Test: Create goal → Submit check-in → Verify in database
- [ ] Test: Create fine → Vote → Fine activates
- [ ] Test: Start jail → Timer sync → Complete jail
- [ ] Test: Upload image to R2 → Verify URL returned
- [ ] Test: Real-time subscription receives updates (WebSocket)

---

### **B. Supabase Integration Tests**

- [ ] Test: RLS policies enforce access control (cannot read other user's data)
- [ ] Test: Database triggers fire correctly (e.g., update streak on check-in)
- [ ] Test: Real-time subscriptions work (new check-in appears in feed)
- [ ] Test: Image upload to Supabase Storage works
- [ ] Test: Auth token refresh works (when token expires)

---

### **C. Family Controls Integration Tests**

**Must test on physical device:**

- [ ] Test: Request authorization shows system prompt
- [ ] Test: Block apps works (actually blocks Instagram, TikTok)
- [ ] Test: Unblock apps works (after jail completes)
- [ ] Test: Timer pause detection works (when app backgrounds)
- [ ] Test: Break jail flow works (pay 2x, unblock immediately)
- [ ] Test: Denied permission handled gracefully (feature unavailable)

---

### **D. Push Notification Tests**

- [ ] Test: Request permission shows system prompt
- [ ] Test: Token saved to database on grant
- [ ] Test: Check-in reminder arrives 30 min before goal time
- [ ] Test: Fine vote notification arrives when fine created
- [ ] Test: Jail started notification arrives for pack members
- [ ] Test: Tap notification deep links to correct screen
- [ ] Test: Notification badge count updates correctly

---

## 📱 PHASE 3: UI TESTING (XCUITest)

### **A. Critical Flow Tests**

#### 1. Onboarding Flow

- [ ] Test: User can enter phone number
- [ ] Test: User can verify OTP code
- [ ] Test: User can create profile (username, avatar)
- [ ] Test: User can enable notifications
- [ ] Test: User can create pack
- [ ] Test: User can join pack with invite code
- [ ] Test: User lands on main feed after onboarding

#### 2. Check-In Flow

- [ ] Test: User can tap "Check In" button
- [ ] Test: Timer countdown displays correctly
- [ ] Test: User can take photo
- [ ] Test: User can retake photo
- [ ] Test: User can add caption
- [ ] Test: User can submit check-in
- [ ] Test: Success screen displays with streak count
- [ ] Test: Check-in appears in feed

#### 3. Fine Voting Flow

- [ ] Test: Fine notification appears as modal
- [ ] Test: User can tap "Activate Fine" button
- [ ] Test: Vote count increments
- [ ] Test: Fine activates when threshold met
- [ ] Test: User sees "Pay Fine" option
- [ ] Test: Fine marked as paid after payment

#### 4. Phone Jail Flow

- [ ] Test: User can select apps to block
- [ ] Test: User can set duration
- [ ] Test: Jail starts with countdown timer
- [ ] Test: Timer displays correctly (MM:SS format)
- [ ] Test: User can break jail (pay 2x)
- [ ] Test: Jail completes and success screen shows

---

### **B. Edge Case Tests**

- [ ] Test: App handles no internet connection gracefully
- [ ] Test: App recovers from interrupted check-in (photo upload fails)
- [ ] Test: App handles expired session (logout and re-auth)
- [ ] Test: App handles push notification when app is terminated
- [ ] Test: App handles multiple concurrent jail sessions (edge case)
- [ ] Test: App handles pack deletion while viewing pack

---

### **C. Accessibility Tests**

- [ ] Test: All interactive elements have VoiceOver labels
- [ ] Test: VoiceOver can navigate through app logically
- [ ] Test: Dynamic Type (text scaling) works correctly
- [ ] Test: Color contrast passes WCAG AA (even with dark theme)
- [ ] Test: Buttons are minimum 44×44pt touch target

---

## 🔍 PHASE 4: MANUAL TESTING

### **A. Device Testing**

Test on multiple devices:

- [ ] **iPhone 14 Pro Max** (6.7", notch, 120Hz)
- [ ] **iPhone 14** (6.1", notch, 60Hz)
- [ ] **iPhone SE (3rd gen)** (4.7", home button, 60Hz)
- [ ] **iPhone 13 mini** (5.4", small screen edge case)

Test on multiple iOS versions:
- [ ] **iOS 18** (latest)
- [ ] **iOS 17** (minimum supported)

---

### **B. Network Conditions**

Use Xcode Network Link Conditioner:

- [ ] Test: App works on Wi-Fi
- [ ] Test: App works on 5G
- [ ] Test: App works on 3G (slow network)
- [ ] Test: App handles intermittent connection (lossy network)
- [ ] Test: App handles offline mode (caches data, queues actions)
- [ ] Test: App syncs correctly when coming back online

---

### **C. Stress Testing**

- [ ] Test: App with 100+ check-ins in feed (scroll performance)
- [ ] Test: App with 10 packs (navigation, data loading)
- [ ] Test: App with 20+ goals (goal list performance)
- [ ] Test: Rapid button taps (prevent duplicate submissions)
- [ ] Test: Image upload while app backgrounds (background tasks)
- [ ] Test: Long jail session (60 min, battery impact)

---

### **D. Real-World Scenarios**

- [ ] Test: Check-in at exactly the deadline (1 second before/after)
- [ ] Test: Multiple users vote on fine simultaneously (race condition)
- [ ] Test: User breaks jail while offline (sync when online)
- [ ] Test: User receives check-in reminder while in jail (notification priority)
- [ ] Test: User deletes app during active jail session (resume on reinstall)
- [ ] Test: Time zone changes mid-check-in window (travel edge case)

---

## 🐛 PHASE 5: BUG TRACKING & RESOLUTION

### **A. Bug Tracking Setup**

- [ ] Set up issue tracker (GitHub Issues or Linear)
- [ ] Create bug report template:
  ```
  **Bug Description:**
  [Clear description of the bug]

  **Steps to Reproduce:**
  1. [Step 1]
  2. [Step 2]
  3. [Step 3]

  **Expected Behavior:**
  [What should happen]

  **Actual Behavior:**
  [What actually happens]

  **Device & iOS Version:**
  [e.g., iPhone 14 Pro, iOS 17.4]

  **Screenshots/Videos:**
  [Attach if applicable]

  **Severity:**
  [ ] Critical (app crash, data loss, core feature broken)
  [ ] High (major feature broken, workaround exists)
  [ ] Medium (minor feature broken, cosmetic issue)
  [ ] Low (typo, minor UI glitch)
  ```

---

### **B. Bug Prioritization**

**Critical (Fix immediately, block release):**
- App crashes on launch
- Cannot create account
- Cannot check in (core flow broken)
- Data loss (check-ins, streaks disappear)
- Phone jail doesn't block apps
- Payment processing fails

**High (Fix before launch):**
- Fine voting doesn't work
- Real-time feed not updating
- Push notifications not arriving
- Image upload fails consistently
- Streak calculation wrong

**Medium (Fix in v1.1):**
- UI glitches (layout issues, wrong colors)
- Missing animations
- Slow loading times (not critical)
- Minor UX issues (confusing wording)

**Low (Backlog):**
- Typos in copy
- Missing accessibility labels
- Feature requests (not bugs)

---

### **C. Regression Testing**

After every bug fix:

- [ ] Re-test the specific bug (verify fixed)
- [ ] Test related features (ensure fix didn't break anything)
- [ ] Run full test suite (unit + UI tests)
- [ ] Smoke test critical flows (auth, check-in, fines, jail)

---

## 📊 PHASE 6: PERFORMANCE TESTING

### **A. App Performance**

Use Xcode Instruments:

- [ ] **Time Profiler:** Identify slow functions (target: <100ms UI response)
- [ ] **Allocations:** Check for memory leaks (retain cycles)
- [ ] **Network:** Monitor API calls (minimize requests, batch if possible)
- [ ] **Energy Log:** Identify battery drain (especially during jail sessions)

**Performance Targets:**
- App launch: <2 seconds (cold start)
- Screen transitions: <300ms
- API calls: <500ms (p95)
- Image loading: <1 second (with placeholder)
- Real-time updates: <500ms latency

---

### **B. Backend Performance**

Use load testing tools (Artillery, k6):

- [ ] Test: 100 concurrent users checking in
- [ ] Test: 1000 req/sec to API (burst load)
- [ ] Test: Real-time WebSocket with 500 connections
- [ ] Test: Database queries under load (should be <50ms)

**Backend Targets:**
- API response time: <200ms (p95)
- Database query time: <50ms (p95)
- WebSocket latency: <500ms
- Image upload: <3 seconds (5MB file)

---

## 🔐 PHASE 7: SECURITY TESTING

### **A. Authentication Security**

- [ ] Test: JWT tokens expire after 30 days
- [ ] Test: Expired tokens trigger re-login
- [ ] Test: Cannot access API without valid token
- [ ] Test: Cannot impersonate other users (user ID in JWT)
- [ ] Test: OTP codes expire after 10 minutes
- [ ] Test: OTP codes are rate-limited (max 3 per hour)

---

### **B. Data Security**

- [ ] Test: RLS policies prevent unauthorized data access
- [ ] Test: Users cannot read other users' private data
- [ ] Test: Users cannot modify other users' data
- [ ] Test: Image URLs are not guessable (use UUIDs)
- [ ] Test: Sensitive data not logged (passwords, tokens, payment info)

---

### **C. API Security**

- [ ] Test: Rate limiting blocks excessive requests (100 req/min)
- [ ] Test: SQL injection attempts fail (parameterized queries)
- [ ] Test: XSS attempts fail (sanitized inputs)
- [ ] Test: CORS only allows pakkt.app domain
- [ ] Test: Webhook signatures verified (Stripe)

---

## 🎭 PHASE 8: BETA TESTING

### **A. Internal Testing (Week 1-2)**

- [ ] Recruit 5-10 team members and friends
- [ ] Create test packs with real usage
- [ ] Use app daily for 2 weeks
- [ ] Document all bugs and UX issues
- [ ] Fix critical and high-priority bugs

---

### **B. Closed Beta (Week 3-4)**

- [ ] Recruit 50-100 beta testers (via TestFlight)
- [ ] Target audience: College students, gym-goers
- [ ] Provide clear instructions and survey
- [ ] Collect feedback:
  - [ ] Onboarding clarity (1-5 rating)
  - [ ] Feature understanding (1-5 rating)
  - [ ] Overall experience (1-5 rating)
  - [ ] Would you pay for this? (Yes/No)
  - [ ] Open feedback (text)

- [ ] Monitor usage:
  - [ ] Retention (D1, D7)
  - [ ] Check-ins per user per week
  - [ ] Fine activation rate
  - [ ] Jail session completion rate

- [ ] Iterate based on feedback (fix major issues)

---

### **C. Public Beta (Optional, Week 5-6)**

- [ ] Expand TestFlight to 1,000+ users
- [ ] Announce on social media (build hype)
- [ ] Collect more feedback
- [ ] Final bug fixes before App Store submission

---

## ✅ PRE-LAUNCH QA CHECKLIST

Before submitting to App Store:

**Critical Flows:**
- [ ] Can sign up with phone number
- [ ] Can verify OTP code
- [ ] Can complete onboarding
- [ ] Can create pack
- [ ] Can join pack with invite code
- [ ] Can create goal
- [ ] Can check in (with photo)
- [ ] Can vote on fine
- [ ] Can start phone jail
- [ ] Can subscribe (in sandbox)
- [ ] Can restore purchases

**Performance:**
- [ ] App launches in <2 seconds
- [ ] No memory leaks detected
- [ ] No excessive battery drain
- [ ] API calls complete in <500ms
- [ ] Image loading works smoothly

**Security:**
- [ ] Authentication works correctly
- [ ] RLS policies enforced
- [ ] No sensitive data logged
- [ ] Rate limiting active

**UI/UX:**
- [ ] No UI glitches on any screen
- [ ] All text is readable (contrast, size)
- [ ] All buttons work as expected
- [ ] Loading states display correctly
- [ ] Error messages are helpful

**Edge Cases:**
- [ ] App handles no internet gracefully
- [ ] App handles expired session correctly
- [ ] App handles push notifications correctly
- [ ] App handles time zone changes
- [ ] App handles concurrent actions (race conditions)

**Devices:**
- [ ] Tested on iPhone 14 Pro Max
- [ ] Tested on iPhone 14
- [ ] Tested on iPhone SE
- [ ] Tested on iOS 17 (minimum)
- [ ] Tested on iOS 18 (latest)

**Analytics:**
- [ ] PostHog tracking all events
- [ ] Sentry capturing all errors
- [ ] Crash reporting configured

**Legal:**
- [ ] Privacy Policy published
- [ ] Terms of Service published
- [ ] Support email configured (support@pakkt.app)

---

## 📈 POST-LAUNCH MONITORING

### **A. Crash Monitoring (Sentry)**

- [ ] Monitor crash rate daily (target: <0.5%)
- [ ] Prioritize crashes by volume (fix most common first)
- [ ] Set up alerts for crash spikes (>1% crash rate)

---

### **B. Performance Monitoring**

- [ ] Monitor API response times (PostHog or Datadog)
- [ ] Monitor app launch time
- [ ] Monitor memory usage
- [ ] Identify and fix performance bottlenecks

---

### **C. User Feedback**

- [ ] Monitor App Store reviews daily
- [ ] Respond to all reviews (positive and negative)
- [ ] Track common complaints (create tickets)
- [ ] Prioritize fixes based on user impact

---

### **D. A/B Testing (Post-Launch)**

- [ ] Test paywall variations (headline, pricing display)
- [ ] Test onboarding flow (3 screens vs 5 screens)
- [ ] Test check-in flow (photo required vs optional)
- [ ] Test fine amounts (default $5 vs $10)
- [ ] Use PostHog or Firebase for A/B tests

---

## 🎯 SUCCESS METRICS

**Quality:**
- <0.5% crash rate
- >4.5 star App Store rating
- <1% refund rate

**Performance:**
- <2 second app launch
- <100ms UI response time
- <500ms API response time (p95)

**Engagement:**
- 60%+ D1 retention
- 40%+ D7 retention
- 8+ app opens per day

---

**Next Steps:**
1. Set up test targets in Xcode
2. Write unit tests for core business logic
3. Set up CI to run tests on every commit
4. Manual test on multiple devices
5. Recruit beta testers (TestFlight)
6. Monitor metrics post-launch and iterate rapidly
