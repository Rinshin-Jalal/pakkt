# PAKKT - iOS APP DEVELOPMENT TODO

> **Goal:** Build a premium, aggressive, addictive iOS app that makes accountability real and social

---

## 🎨 DESIGN SYSTEM FIRST

### **A. Colors & Theme**

- [ ] Create `PakktColors.swift`:
  ```swift
  struct PakktColors {
    // Foundation
    static let pureBlack = Color(hex: "#000000")
    static let deepGray = Color(hex: "#0A0A0A")
    static let charcoal = Color(hex: "#1A1A1A")
    static let darkGray = Color(hex: "#2A2A2A")

    // Neon Accents
    static let electricCyan = Color(hex: "#00F0FF")
    static let hotMagenta = Color(hex: "#FF006E")
    static let acidYellow = Color(hex: "#FFFF00")
    static let toxicGreen = Color(hex: "#39FF14")
    static let deepPurple = Color(hex: "#7B2CBF")
    static let orangeFire = Color(hex: "#FF6B35")

    // Semantic Colors
    static let primary = electricCyan
    static let danger = hotMagenta
    static let warning = acidYellow
    static let success = toxicGreen
    static let premium = deepPurple
    static let streak = orangeFire
  }
  ```

- [ ] Create `GlassMorphism.swift` modifier:
  ```swift
  struct GlassMorphism: ViewModifier {
    let opacity: Double = 0.15
    let blur: CGFloat = 60

    func body(content: Content) -> some View {
      content
        .background(.ultraThinMaterial)
        .background(
          PakktColors.deepGray.opacity(opacity)
        )
        .cornerRadius(16)
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(PakktColors.electricCyan, lineWidth: 3)
        )
    }
  }
  ```

- [ ] Create `NeonGlow.swift` modifier for neon effects
- [ ] Create `BrutalShadow.swift` modifier for hard shadows
- [ ] Create color palette asset catalog

---

### **B. Typography**

- [ ] Create `PakktTypography.swift`:
  ```swift
  struct PakktTypography {
    // Headers (SF Pro Display Black)
    static let h1 = Font.system(size: 48, weight: .black, design: .default)
    static let h2 = Font.system(size: 36, weight: .black, design: .default)
    static let h3 = Font.system(size: 28, weight: .black, design: .default)

    // Body (SF Pro)
    static let bodyLarge = Font.system(size: 18, weight: .semibold)
    static let body = Font.system(size: 16, weight: .medium)
    static let bodySmall = Font.system(size: 14, weight: .regular)

    // Labels (All caps encouraged)
    static let label = Font.system(size: 12, weight: .bold).uppercased()
    static let caption = Font.system(size: 10, weight: .semibold)
  }
  ```

- [ ] Create `AllCapsText` component for aggressive labels
- [ ] Add letter spacing for headings
- [ ] Define line heights and spacing

---

### **C. Reusable Components**

#### 1. Buttons

- [ ] `PrimaryButton.swift` - Neon cyan with brutal shadow
  ```swift
  struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
      Button(action: action) {
        Text(title.uppercased())
          .font(PakktTypography.bodyLarge)
          .foregroundColor(PakktColors.pureBlack)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16)
          .background(PakktColors.electricCyan)
          .cornerRadius(12)
          .shadow(
            color: PakktColors.electricCyan.opacity(0.5),
            radius: 20, x: 0, y: 8
          )
      }
    }
  }
  ```

- [ ] `DangerButton.swift` - Hot magenta for fines/jail
- [ ] `SecondaryButton.swift` - Outlined with glass background
- [ ] `IconButton.swift` - Circular with single icon
- [ ] `DestructiveButton.swift` - Red for delete/cancel

#### 2. Cards

- [ ] `GlassCard.swift` - Base glass morphism card
- [ ] `PackCard.swift` - Pack preview card for list
- [ ] `CheckInCard.swift` - Check-in feed item
- [ ] `FineCard.swift` - Fine notification card
- [ ] `JailCard.swift` - Phone jail status card
- [ ] `StatsCard.swift` - User/pack statistics display

#### 3. Input Fields

- [ ] `PakktTextField.swift` - Glass background with neon border
- [ ] `PakktPhoneField.swift` - Phone number input with formatting
- [ ] `PakktTextEditor.swift` - Multi-line text (for bio, captions)
- [ ] `PakktPicker.swift` - Custom picker with glass style
- [ ] `PakktSlider.swift` - Neon slider for amounts/durations

#### 4. Media Components

- [ ] `AvatarView.swift` - Circular avatar with border
- [ ] `PackAvatarGrid.swift` - Overlapping pack member avatars
- [ ] `CheckInPhotoView.swift` - Square photo with glass overlay
- [ ] `ImagePicker.swift` - Custom camera/library picker

#### 5. Status & Indicators

- [ ] `StreakBadge.swift` - Fire icon with count
- [ ] `FineAmountBadge.swift` - Dollar amount with magenta
- [ ] `JailTimerView.swift` - Countdown timer (large, animated)
- [ ] `LoadingSpinner.swift` - Neon spinning loader
- [ ] `ProgressBar.swift` - Neon progress indicator

#### 6. Navigation

- [ ] `PakktTabBar.swift` - Custom tab bar (dark glass)
- [ ] `PakktNavBar.swift` - Custom navigation bar
- [ ] `BackButton.swift` - Consistent back button style
- [ ] `MoreMenuButton.swift` - Three-dot menu

---

## 📱 FEATURE DEVELOPMENT (BY PHASE)

### **PHASE 1: AUTHENTICATION & ONBOARDING**

#### A. Splash Screen

- [ ] Create `SplashView.swift`
- [ ] Pakkt logo animation (neon glow)
- [ ] Check authentication status
- [ ] Route to login or main app
- [ ] Black background with neon accents

#### B. Phone Authentication

- [ ] Create `LoginView.swift`
  - [ ] Phone number input (international format)
  - [ ] "SEND CODE" button
  - [ ] Call Supabase Auth (OTP)
  - [ ] Handle errors (invalid number, rate limit)

- [ ] Create `OTPVerificationView.swift`
  - [ ] 6-digit code input
  - [ ] Auto-submit on completion
  - [ ] Resend code button (30s cooldown)
  - [ ] Verify with Supabase Auth
  - [ ] Store JWT in Keychain
  - [ ] Navigate to onboarding or main app

- [ ] Create `AuthViewModel.swift`
  - [ ] `@Published var isAuthenticated: Bool`
  - [ ] `func sendOTP(phoneNumber: String) async throws`
  - [ ] `func verifyOTP(code: String) async throws`
  - [ ] `func logout()`
  - [ ] Listen to Supabase Auth state changes

#### C. Onboarding Flow (First-Time Users)

- [ ] Create `OnboardingContainerView.swift` (manages flow)

- [ ] **Screen 1: Welcome**
  - [ ] Aggressive tagline: "SHOW UP OR PAY UP"
  - [ ] Brief explanation (3 bullets max)
  - [ ] "LET'S GO" button

- [ ] **Screen 2: Create Profile**
  - [ ] Username input (unique, validated)
  - [ ] Display name input
  - [ ] Optional: Avatar photo upload
  - [ ] Optional: Bio (1-2 sentences)

- [ ] **Screen 3: Notification Permission**
  - [ ] Explain why (check-in reminders, fine votes, jail alerts)
  - [ ] "ENABLE NOTIFICATIONS" button
  - [ ] Request `UNAuthorizationCenter` permission
  - [ ] Handle accept/deny

- [ ] **Screen 4: Create or Join Pack**
  - [ ] Two options: "CREATE PACK" or "JOIN PACK"
  - [ ] If create: Pack name input → done
  - [ ] If join: Enter invite code → validate → done
  - [ ] Save pack to database

- [ ] **Screen 5: Family Controls Permission (Critical)**
  - [ ] Explain phone jail feature
  - [ ] "This is what makes Pakkt real"
  - [ ] "ENABLE PHONE JAIL" button
  - [ ] Request `FamilyControls` authorization
  - [ ] If denied: Still allow app, mark feature as unavailable
  - [ ] Complete onboarding

- [ ] Create `OnboardingViewModel.swift`
  - [ ] Track current step
  - [ ] Validate inputs
  - [ ] Call API to create user profile
  - [ ] Handle errors gracefully

---

### **PHASE 1: PACKS (FRIEND GROUPS)**

#### A. Pack List View

- [ ] Create `PackListView.swift`
  - [ ] List of user's packs (horizontal carousel or vertical)
  - [ ] Each pack shows: Avatar, name, member count, active goals
  - [ ] "+" button to create new pack
  - [ ] Tap pack → `PackDetailView`

- [ ] Create `PackListViewModel.swift`
  - [ ] `@Published var packs: [Pack]`
  - [ ] `func fetchPacks() async`
  - [ ] `func createPack(name: String) async throws`
  - [ ] Real-time subscription to pack updates

#### B. Pack Detail View

- [ ] Create `PackDetailView.swift`
  - [ ] Pack header: Avatar, name, description
  - [ ] Member grid (avatars + usernames)
  - [ ] Active goals list
  - [ ] Check-in feed (recent activity)
  - [ ] "SETTINGS" button
  - [ ] "INVITE" button (generate shareable link)

- [ ] Create `PackMembersView.swift`
  - [ ] List all members with stats:
    - Current streak
    - Total check-ins
    - Total fines paid
  - [ ] Admin actions: Remove member (if you're admin)

- [ ] Create `PackSettingsView.swift`
  - [ ] Edit pack name, description, avatar
  - [ ] Set default fine amount ($1-$20)
  - [ ] Set default jail duration (15-60 min)
  - [ ] Set min votes for fine activation
  - [ ] Delete pack (admin only, confirm dialog)

- [ ] Create `PackInviteView.swift`
  - [ ] Generate invite code (6 characters, unique)
  - [ ] Display as QR code
  - [ ] Share via Messages, Instagram, etc.
  - [ ] Copy link button

#### C. Join Pack Flow

- [ ] Create `JoinPackView.swift`
  - [ ] Enter invite code input
  - [ ] "JOIN PACK" button
  - [ ] Validate code with API
  - [ ] Show pack preview before joining
  - [ ] Confirm and join
  - [ ] Navigate to pack detail

- [ ] Handle deep links: `pakkt://pack/join?code=ABC123`
  - [ ] Parse URL
  - [ ] Auto-fill invite code
  - [ ] Present join flow

---

### **PHASE 1: GOALS & CHECK-INS**

#### A. Goal Creation

- [ ] Create `CreateGoalView.swift`
  - [ ] Goal title input (e.g., "GYM")
  - [ ] Goal description (optional)
  - [ ] Check-in time picker (Time, not Date)
  - [ ] Fine amount slider ($1-$20, pack default pre-filled)
  - [ ] Jail duration picker (15, 30, 45, 60 min)
  - [ ] Require photo toggle
  - [ ] "CREATE GOAL" button

- [ ] Create `GoalListView.swift`
  - [ ] List user's goals (grouped by pack)
  - [ ] Each goal shows: Title, check-in time, streak
  - [ ] Color-coded status: Checked in today (green), pending (yellow), missed (red)
  - [ ] Tap goal → Goal detail
  - [ ] "+" button to create new goal

- [ ] Create `GoalDetailView.swift`
  - [ ] Goal info (title, time, fine, jail)
  - [ ] Check-in history (calendar view)
  - [ ] Streak stats (current, longest)
  - [ ] Edit/Delete buttons
  - [ ] "CHECK IN NOW" button (if within window)

#### B. Check-In Flow

- [ ] Create `CheckInView.swift`
  - [ ] Large goal title at top
  - [ ] Timer: "5 minutes left to check in" (countdown)
  - [ ] Camera button: Take photo (optional but encouraged)
  - [ ] Photo preview (retake option)
  - [ ] Caption input (optional, 1-2 sentences)
  - [ ] "SUBMIT CHECK-IN" button (big, neon green)
  - [ ] Success animation (confetti, streak count)

- [ ] Create `CheckInViewModel.swift`
  - [ ] `@Published var timeRemaining: TimeInterval`
  - [ ] `func startTimer()`
  - [ ] `func uploadPhoto() async throws -> URL`
  - [ ] `func submitCheckIn() async throws`
  - [ ] Handle errors (late check-in → trigger fine vote)

#### C. Check-In Reminders

- [ ] Create `NotificationManager.swift`
  - [ ] Schedule local notifications 30 min before each goal
  - [ ] Notification title: "GYM CHECK-IN - 30 MIN"
  - [ ] Notification body: "Your pack is watching. Don't miss it."
  - [ ] Deep link to `CheckInView` for that goal
  - [ ] Reschedule daily at midnight

- [ ] Handle missed check-ins:
  - [ ] Background task: Check for missed check-ins
  - [ ] Auto-create fine if user missed goal
  - [ ] Notify pack members to vote on fine

---

### **PHASE 2: FINES SYSTEM**

#### A. Fine Creation & Voting

- [ ] Create `FineNotificationView.swift` (appears as modal)
  - [ ] "TOM MISSED GYM 💀"
  - [ ] Fine amount: "$5"
  - [ ] Voting options: "ACTIVATE FINE" or "LET IT SLIDE"
  - [ ] Vote count: "2/3 votes needed"
  - [ ] Timer: "Voting ends in 2 hours"

- [ ] Create `FineListView.swift`
  - [ ] List of active fines (pending, paid, disputed)
  - [ ] Filter by status
  - [ ] Tap fine → `FineDetailView`

- [ ] Create `FineDetailView.swift`
  - [ ] Fine amount (large, magenta)
  - [ ] Reason: "Missed GYM - Jan 15"
  - [ ] Voting results: Who voted for/against
  - [ ] If user owes: "PAY NOW" button
  - [ ] Payment options: Venmo, Cash App, Honor System
  - [ ] Dispute button (opens dispute flow)

- [ ] Create `FineViewModel.swift`
  - [ ] `@Published var activeFines: [Fine]`
  - [ ] `func voteOnFine(fineId: UUID, vote: Bool) async throws`
  - [ ] `func payFine(fineId: UUID, method: PaymentMethod) async throws`
  - [ ] Real-time subscription to fine votes

#### B. Payment Processing (Honor System → Real Money)

**Phase 1: Honor System (MVP)**
- [ ] "Mark as paid" button
- [ ] Notify pack members when marked paid
- [ ] Pack admin can verify/dispute

**Phase 2: Real Money (Post-Launch)**
- [ ] Integrate Stripe Checkout
- [ ] Link Venmo/Cash App (external links for now)
- [ ] Track payment status in database
- [ ] Auto-split to pack pool or distribute to members

---

### **PHASE 2: PHONE JAIL**

#### A. Jail Activation

- [ ] Create `PhoneJailSetupView.swift`
  - [ ] Select apps to block (Instagram, TikTok, etc.)
  - [ ] Use `FamilyActivityPicker` from FamilyControls
  - [ ] Set duration (15, 30, 45, 60 min, pack default pre-filled)
  - [ ] Preview: "You'll be locked out of these apps"
  - [ ] "START JAIL" button (big, yellow)

- [ ] Create `PhoneJailActiveView.swift` (full-screen takeover)
  - [ ] Large countdown timer (center, animated)
  - [ ] "YOU'RE IN JAIL" header
  - [ ] Blocked apps list (grayed out)
  - [ ] Pack members can comment (live feed at bottom)
  - [ ] "BREAK JAIL (PAY 2X)" button (small, bottom)
  - [ ] Warning: "If you close this app, timer pauses"

- [ ] Create `PhoneJailViewModel.swift`
  - [ ] `@Published var jailSession: PhoneJail?`
  - [ ] `func startJail(apps: [Application], duration: Int) async throws`
  - [ ] `func monitorAppState()` - Pause timer if app backgrounded
  - [ ] `func breakJail() async throws` - Pay 2x fine
  - [ ] Real-time sync timer with backend (prevent cheating)

#### B. Family Controls Integration

- [ ] Request authorization: `AuthorizationCenter.shared.requestAuthorization()`
- [ ] Use `DeviceActivityMonitor` to enforce blocks
- [ ] Use `ShieldConfiguration` to display blocking screen
- [ ] Block apps during jail session
- [ ] Unblock apps when timer completes
- [ ] Handle timer pause if app is killed (resume on relaunch)

#### C. Jail Completion

- [ ] Show celebration screen: "YOU SURVIVED 💪"
- [ ] Share button: "I survived 30 min of phone jail" (Instagram Story)
- [ ] Update user stats (total jails completed)
- [ ] Notify pack members

---

### **PHASE 3: SOCIAL FEED**

#### A. Main Feed View (BeReal Style)

- [ ] Create `FeedView.swift`
  - [ ] Top: Today's check-ins from all packs
  - [ ] Layout: Vertical list, each check-in is a card
  - [ ] Card shows:
    - User avatar + username
    - Check-in time (e.g., "2 min ago")
    - Photo (if uploaded)
    - Caption
    - Streak badge (if milestone)
    - Reactions (emoji bar at bottom)
    - Comment count
  - [ ] Pull to refresh
  - [ ] Real-time updates (new check-ins appear instantly)

- [ ] Create `FeedViewModel.swift`
  - [ ] `@Published var feedItems: [CheckIn]`
  - [ ] `func fetchFeed() async`
  - [ ] Subscribe to Supabase real-time: `check_ins` table
  - [ ] Handle new check-in events
  - [ ] Optimistic UI updates

#### B. Reactions & Comments

- [ ] Create `ReactionBar.swift` component
  - [ ] Emoji options: 💀 🔥 💪 👑 😂 💸
  - [ ] Show count per emoji
  - [ ] Tap emoji to add/remove reaction
  - [ ] Animate when reaction added

- [ ] Create `CommentView.swift`
  - [ ] List of comments under check-in
  - [ ] Each comment: Avatar, username, text, time
  - [ ] Text input at bottom
  - [ ] "SEND" button
  - [ ] Real-time comment updates

- [ ] Create `CommentsViewModel.swift`
  - [ ] `@Published var comments: [Comment]`
  - [ ] `func postComment(text: String) async throws`
  - [ ] Subscribe to real-time comment updates

---

### **PHASE 3: STATS & GAMIFICATION**

#### A. User Profile

- [ ] Create `ProfileView.swift`
  - [ ] Avatar (large, circular)
  - [ ] Username + display name
  - [ ] Bio
  - [ ] Stats grid:
    - Current streak (fire emoji)
    - Longest streak
    - Total check-ins
    - Total fines paid
    - Total jails completed
  - [ ] "EDIT PROFILE" button
  - [ ] "SETTINGS" button
  - [ ] "SHARE PROFILE" button (Instagram Story)

- [ ] Create `EditProfileView.swift`
  - [ ] Edit username (check availability)
  - [ ] Edit display name
  - [ ] Edit bio
  - [ ] Change avatar photo
  - [ ] Save changes

#### B. Pack Leaderboard

- [ ] Create `PackLeaderboardView.swift`
  - [ ] Rank members by current streak
  - [ ] Show top 3 with podium (1st, 2nd, 3rd)
  - [ ] Full list below
  - [ ] Each row: Rank, avatar, name, streak count
  - [ ] Filter options: This week, this month, all-time

#### C. Achievements (Optional Phase 2)

- [ ] Achievement types:
  - "Week Warrior" - 7-day streak
  - "Unstoppable" - 30-day streak
  - "Untouchable" - 100-day streak
  - "Rich" - Paid $100+ in fines
  - "Survivor" - Completed 10 jails
  - "Bouncer" - Started 10 jails for others

- [ ] Create `AchievementsView.swift`
  - [ ] Grid of achievement badges
  - [ ] Unlocked vs locked (grayed out)
  - [ ] Tap badge → Show details and progress

---

### **PHASE 4: SUBSCRIPTIONS & PAYWALL**

#### A. Paywall Design

- [ ] Create `PaywallView.swift`
  - [ ] Aggressive headline: "UNLOCK FULL PAKKT"
  - [ ] Benefits list (3-5 bullets):
    - "Real phone jail (blocks apps)"
    - "Unlimited packs and goals"
    - "Advanced analytics"
    - "Priority support"
  - [ ] Pricing options (tabs):
    - **ANNUAL: $49/year** (BEST VALUE, 76% off)
    - Weekly: $4/week
  - [ ] Show savings: "Save $159/year!"
  - [ ] "START 3-DAY FREE TRIAL" button (annual only)
  - [ ] "Terms" and "Restore purchases" links at bottom

- [ ] Paywall triggers:
  - [ ] After 3 check-ins (trial limit)
  - [ ] When trying to create 2nd pack
  - [ ] When trying to start phone jail without subscription
  - [ ] Manually from settings

#### B. RevenueCat Integration

- [ ] Install RevenueCat SDK via SPM
- [ ] Initialize SDK in `AppDelegate` / `App.swift`
- [ ] Create `SubscriptionManager.swift`:
  - [ ] `func fetchOfferings() async throws -> Offerings`
  - [ ] `func purchase(package: Package) async throws`
  - [ ] `func restorePurchases() async throws`
  - [ ] `@Published var subscriptionStatus: SubscriptionStatus`
  - [ ] Listen to RevenueCat updates

- [ ] Create `SubscriptionViewModel.swift`
  - [ ] Present paywall when needed
  - [ ] Handle purchase flow
  - [ ] Show loading states
  - [ ] Handle errors (payment failed, cancelled)
  - [ ] Update UI based on subscription status

- [ ] Sync subscription status with Supabase:
  - [ ] After successful purchase → Update `users.subscription_status`
  - [ ] Webhook from RevenueCat → Update database

#### C. Feature Gating

- [ ] Create `FeatureGate.swift` utility:
  ```swift
  func requiresSubscription(feature: Feature) -> Bool {
    switch feature {
    case .phoneJail, .unlimitedPacks, .analytics:
      return true
    case .basicCheckIns, .onePack:
      return false
    }
  }
  ```

- [ ] Wrap premium features with gate:
  ```swift
  if FeatureGate.canAccess(.phoneJail) {
    // Show phone jail UI
  } else {
    // Show paywall
  }
  ```

---

### **PHASE 5: POLISH & APP STORE PREP**

#### A. App Icon & Assets

- [ ] Design app icon (1024x1024):
  - [ ] Dark background (pure black or gradient)
  - [ ] Neon accent (cyan or magenta)
  - [ ] Pakkt logo or symbol
  - [ ] Export all required sizes (AppIcon.appiconset)

- [ ] Launch screen:
  - [ ] Black background
  - [ ] Pakkt logo (center, animated optional)
  - [ ] Neon glow effect

- [ ] Create asset catalog for all images:
  - [ ] Empty state illustrations
  - [ ] Onboarding graphics
  - [ ] Achievement badges
  - [ ] Icons (SF Symbols + custom)

#### B. Settings Screen

- [ ] Create `SettingsView.swift`
  - [ ] Account section:
    - Profile settings
    - Phone number
    - Logout
  - [ ] Subscription section:
    - Current plan
    - Manage subscription (link to App Store)
    - Restore purchases
  - [ ] Notifications section:
    - Push notification toggle
    - Check-in reminders toggle
    - Fine vote alerts toggle
  - [ ] Privacy section:
    - Privacy Policy (link)
    - Terms of Service (link)
    - Data export
    - Delete account
  - [ ] Support section:
    - Help & FAQ (link)
    - Contact support (email)
    - Rate app (link to App Store)
  - [ ] App info:
    - Version number
    - Build number

#### C. Accessibility

- [ ] Add VoiceOver labels to all interactive elements
- [ ] Support Dynamic Type (text scaling)
- [ ] Ensure color contrast meets WCAG AA (even with dark theme)
- [ ] Test with VoiceOver enabled
- [ ] Add accessibility identifiers for UI testing

#### D. Localization (English Only for MVP)

- [ ] Extract all strings to `Localizable.strings`
- [ ] Use `NSLocalizedString` everywhere
- [ ] Plan for future: Spanish, French, German

#### E. Performance Optimization

- [ ] Optimize images (compress, use appropriate formats)
- [ ] Lazy load feed images (pagination)
- [ ] Cache network responses (URLCache)
- [ ] Prefetch data for smooth scrolling
- [ ] Profile with Instruments (CPU, Memory, Network)
- [ ] Reduce app size (strip unused code, assets)

#### F. Error Handling & Offline Support

- [ ] Create `ErrorView.swift` - Generic error screen
- [ ] Handle common errors:
  - No internet connection
  - API timeout
  - 500 server error
  - Invalid session (token expired)
- [ ] Offline mode (basic):
  - Cache user profile and pack list
  - Show cached data with "Offline" indicator
  - Queue actions (check-ins, votes) to sync when online
- [ ] Retry failed requests automatically (3 attempts)

---

## 🧪 TESTING

### Unit Tests

- [ ] Test `AuthViewModel` logic (login, verify, logout)
- [ ] Test `CheckInViewModel` (timer, submission)
- [ ] Test `FineViewModel` (voting, payment)
- [ ] Test `PhoneJailViewModel` (timer, pause, break)
- [ ] Test networking layer (API client, error handling)
- [ ] Test data models (Codable encoding/decoding)

### UI Tests

- [ ] Test onboarding flow end-to-end
- [ ] Test pack creation and joining
- [ ] Test goal creation
- [ ] Test check-in submission (without photo)
- [ ] Test fine voting
- [ ] Test subscription purchase (sandbox)

### Manual Testing

- [ ] Test on iPhone 14, 14 Pro, SE (different sizes)
- [ ] Test on iOS 17.0 (minimum) and latest
- [ ] Test with slow network (Network Link Conditioner)
- [ ] Test with VoiceOver enabled
- [ ] Test push notifications (local and remote)
- [ ] Test Family Controls on physical device
- [ ] Test with multiple users (create test accounts)

---

## 📦 BUILD & DISTRIBUTION

### TestFlight Setup

- [ ] Create App Store Connect account
- [ ] Register app: "Pakkt"
- [ ] Bundle ID: `com.pakkt.ios`
- [ ] Upload build to App Store Connect
- [ ] Create internal testing group (team members)
- [ ] Create external testing group (beta users)
- [ ] Write beta testing instructions
- [ ] Distribute TestFlight link

### App Store Submission

- [ ] App Information:
  - [ ] Name: "Pakkt"
  - [ ] Subtitle: "Social Accountability"
  - [ ] Keywords: accountability, goals, habits, friends, productivity
  - [ ] Primary category: Productivity
  - [ ] Secondary category: Social Networking
  - [ ] Age rating: 12+ (Infrequent/Mild: Profanity, Mature/Suggestive Themes)

- [ ] App Description (4000 char max):
  - [ ] Aggressive, no-BS copy
  - [ ] Highlight phone jail (unique feature)
  - [ ] Mention real consequences (fines)
  - [ ] Social proof ("Your boys won't let this slide")
  - [ ] CTA: "Download now and show up."

- [ ] Screenshots (8 required):
  - [ ] 1: Main feed (check-ins)
  - [ ] 2: Phone jail countdown (dramatic)
  - [ ] 3: Pack view (friend grid)
  - [ ] 4: Check-in flow (camera)
  - [ ] 5: Fine notification (voting)
  - [ ] 6: Streak stats (celebrating)
  - [ ] 7: Paywall (aggressive)
  - [ ] 8: Profile stats (achievements)

- [ ] App Preview Video (optional but recommended):
  - [ ] 30 seconds max
  - [ ] Show core flow: Goal → Check-in → Missed → Fine → Phone Jail
  - [ ] Fast-paced, aggressive music
  - [ ] End with tagline: "SHOW UP OR PAY UP"

- [ ] Privacy Information:
  - [ ] Privacy Policy URL: https://pakkt.app/privacy
  - [ ] Data collected: Phone number, photos, usage data
  - [ ] Linked to user identity: Yes
  - [ ] Used for tracking: No (analytics only)
  - [ ] Third-party SDKs: Supabase, Stripe, RevenueCat, Sentry, PostHog

- [ ] App Review Information:
  - [ ] Contact: your email
  - [ ] Phone: your phone
  - [ ] Demo account credentials (for reviewers)
  - [ ] Notes:
    - "Family Controls entitlement required for phone jail feature"
    - "Attach justification document explaining use case"
    - "Similar to apps: Opal, Freedom, one sec"
    - "Democratic voting prevents abuse"

- [ ] Submit for review
- [ ] Monitor status daily
- [ ] Respond to reviewer questions within 24 hours
- [ ] If rejected: Fix issues and resubmit immediately

---

## 🎯 LAUNCH DAY CHECKLIST

- [ ] App approved and live on App Store
- [ ] All critical bugs fixed
- [ ] Push notifications working
- [ ] Subscriptions processing correctly
- [ ] Analytics tracking all events
- [ ] Crash reporting configured (Sentry)
- [ ] Support email monitored: support@pakkt.app
- [ ] Social media accounts active (@pakkt.app)
- [ ] Landing page live (pakkt.app)
- [ ] Press kit ready
- [ ] Influencers seeded
- [ ] Campus ambassadors activated
- [ ] Monitor App Store reviews and respond
- [ ] Monitor metrics dashboard (PostHog)
- [ ] Celebrate 🎉

---

## 📊 SUCCESS METRICS

**User Engagement:**
- 8+ app opens per day
- 5+ check-ins per user per week
- 60% of users in at least one active pack
- 40% D7 retention

**Conversion:**
- 10% paywall → purchase conversion
- 70% choose annual plan
- <5% refund rate

**Quality:**
- <0.5% crash rate
- >4.5 star App Store rating
- <24hr support response time

---

**Next:** Start with design system implementation and authentication flow!
