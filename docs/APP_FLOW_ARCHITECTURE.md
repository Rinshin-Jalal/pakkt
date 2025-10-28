# Pakkt App Flow Architecture

## 🎯 Overview
This document outlines the complete user journey through Pakkt, from first launch to core features.

---

## 📱 App Entry Point

### PakktApp.swift
- Main entry point
- Initializes `AppCoordinator`
- Handles push notifications
- Manages real-time feed updates

### RootView.swift (Current State)
**Decision Tree:**
```
Launch App
└─> Check isAuthenticated
    ├─> NO → Show Auth Flow
    ├─> YES → Check hasCompletedOnboarding
        ├─> NO → Show Onboarding Flow
        └─> YES → Show Main App (TabView)
```

**Current Issue:** `isAuthenticated` and `hasCompletedOnboarding` are hardcoded to `true` for testing.

---

## 🔐 Authentication State Management

### What We Need:
1. **AuthService** - Manages Supabase auth state
   - Check if user is logged in
   - Store/retrieve auth tokens
   - Handle Apple Sign In
   - Handle sign out

2. **SessionManager** - Tracks user session
   - Current user ID
   - User profile data
   - Pack membership status
   - Onboarding completion status

3. **UserDefaults Keys** for persistence:
   - `hasCompletedOnboarding`: Bool
   - `hasCompletedInviteOnboarding`: Bool
   - `currentPackId`: String?
   - `userId`: String?

---

## 🚀 User Flows

### Flow 1: First-Time User (Normal Onboarding)

```
App Launch
└─> No Auth Token
    └─> AuthView (Sign In with Apple)
        └─> Apple Auth Success
            └─> Check Supabase for user record
                ├─> User Exists → Check hasCompletedOnboarding
                │   ├─> NO → Start Normal Onboarding (33 steps)
                │   └─> YES → Navigate to Feed
                └─> New User → Start Normal Onboarding (33 steps)
                    └─> Collect data through 33 steps:
                        1. Welcome
                        2. Why Pakkt Works (value prop)
                        3. Jail Timer Animation
                        4. Name Input
                        5. Username Input
                        6. Profile Photo Upload
                        7. Pack Naming
                        8. Pack Icon Selection
                        9. Goal Definition
                        10. Time Selection (Carousel)
                        11. Check-in Window Duration
                        12. Late Penalty Selection
                        13. Miss Penalty Selection
                        14. Voting System Explanation
                        15. Phone Jail Explanation
                        16. App Selection (for jail)
                        17. Voting Majority Type
                        18. Quick Facts Carousel
                        19. Cost Awareness (calculator)
                        20. Pack Privacy Settings
                        21. Pack Description
                        22. Member Count Selection
                        23. Invite Method Selection
                        24. Invite Contacts
                        25-28. Additional settings
                        29-31. Final confirmation
                        32. Subscription (Paywall)
                        33. Success/Launch
                    └─> OnboardingData Model stores all inputs
                        └─> On Step 33: Send to backend
                            └─> Create user profile
                            └─> Create pack
                            └─> Set goals/rules
                            └─> Send invites
                            └─> Set hasCompletedOnboarding = true
                                └─> Navigate to Feed
```

### Flow 2: Invited User (Invite Onboarding)

```
User Receives Invite Link/Notification
└─> Open Link (Deep Link Handler)
    └─> Check Auth Token
        ├─> No Token → AuthView (Sign In with Apple)
        │   └─> Auth Success → Resume Invite Flow
        └─> Has Token → Start Invite Onboarding (9 steps)
            1. Invite Landing (Pack preview, FOMO)
            2. Value Preview Carousel (3 cards)
            3. Social Proof (emotional pitch)
            4. Pact Preview (goal, stakes)
            4.5. Show Other Members' Signatures
            5. Signature Canvas (ritual)
            6. Pack Seal (validation)
            7. Value Reveal (unlocked features)
            8. Paywall (social framing)
            9. Success → Navigate to Feed
```

### Flow 3: Returning User

```
App Launch
└─> Has Auth Token
    └─> Token Valid
        └─> Check hasCompletedOnboarding
            ├─> NO → Resume Onboarding (at last step)
            └─> YES → Check Pack Membership
                ├─> Has Active Pack → Navigate to Feed
                └─> No Active Pack → Navigate to Pack Discovery/Create
```

---

## 🏗️ Data Flow Architecture

### OnboardingData Model (Shared State)
```swift
@Observable
class OnboardingData {
    // User Profile
    var name: String = ""
    var username: String = ""
    var profilePhotoUrl: String?
    
    // Pack Creation
    var packName: String = ""
    var packIcon: String = ""
    var packDescription: String = ""
    var packPrivacy: PackPrivacy = .private
    
    // Goal Settings
    var goalName: String = ""
    var goalTime: Date = Date()
    var checkInWindow: Int = 30 // minutes
    var latePenalty: Penalty?
    var missPenalty: Penalty?
    
    // Pack Rules
    var votingMajority: VotingType = .simple
    var selectedApps: [String] = []
    
    // Members
    var expectedMembers: Int = 4
    var invitedContacts: [Contact] = []
    
    // Subscription
    var hasSubscribed: Bool = false
}
```

### InviteData Model
```swift
@Observable
class InviteData {
    var packId: String
    var inviteCode: String
    var packName: String
    var goalName: String
    var memberNames: [String]
    var signature: UIImage?
    var hasSubscribed: Bool = false
}
```

---

## 🎛️ Controllers & Coordinators

### OnboardingFlowController
- Manages navigation through 33 normal onboarding steps
- Holds reference to `OnboardingData`
- Methods:
  - `nextStep()` - Navigate forward
  - `previousStep()` - Navigate back
  - `skipTo(step: Int)` - Jump to specific step
  - `completeOnboarding()` - Send data to backend, mark complete

### InviteFlowController
- Manages navigation through 9 invite onboarding steps
- Holds reference to `InviteData`
- Methods:
  - `nextStep()`
  - `previousStep()`
  - `completeInvite()` - Join pack, subscribe, mark complete

### AppCoordinator (Already Exists)
- Global navigation coordinator
- Manages tab selection
- Handles deep links
- Methods to navigate between major sections

---

## 🔄 State Persistence

### What Gets Saved Where:

**UserDefaults (Local):**
- `hasCompletedOnboarding`: Bool
- `hasCompletedInviteOnboarding`: Bool
- `lastOnboardingStep`: Int (resume capability)

**Keychain (Secure):**
- Supabase auth token
- User ID
- Refresh token

**Supabase Database:**
- Complete user profile
- Pack membership
- Goals and rules
- Check-in history
- Voting records
- Jail sessions

---

## 🎯 Main App Features (Post-Onboarding)

### Tab 1: Feed (Primary Tab)
**What Users See:**
- Check-in cards (sorted by time)
- Voting cards (active votes)
- Jail announcements
- Streak celebrations
- Late warnings

**Navigation From Feed:**
- Tap check-in → CheckInDetailView
- Tap vote card → VotingFullView
- Tap jail status → JailSystemView
- Tap profile → UserProfileView

### Tab 2: Profile
**What Users See:**
- Personal stats
- Pack membership
- Settings

**Navigation From Profile:**
- Edit Profile
- Pack Rules (if admin)
- Settings
- About

---

## ⚡ Critical Missing Pieces

### 1. AuthService
**Purpose:** Manage authentication state
**Needs:**
```swift
class AuthService {
    func checkAuthStatus() async -> Bool
    func signInWithApple() async throws -> User
    func signOut() async throws
    func getCurrentUser() -> User?
}
```

### 2. OnboardingStateManager
**Purpose:** Track onboarding progress
**Needs:**
```swift
class OnboardingStateManager {
    func hasCompletedOnboarding() -> Bool
    func saveOnboardingProgress(step: Int)
    func getLastCompletedStep() -> Int
    func markOnboardingComplete()
}
```

### 3. PackMembershipManager
**Purpose:** Track user's pack status
**Needs:**
```swift
class PackMembershipManager {
    func getUserPacks() async -> [Pack]
    func getActivePack() async -> Pack?
    func joinPack(inviteCode: String) async throws
}
```

### 4. DeepLinkRouter
**Purpose:** Handle invite links
**Needs:**
```swift
class DeepLinkRouter {
    func handleInviteLink(url: URL) -> InviteData?
    func handlePackLink(url: URL) -> String? // packId
}
```

---

## 🚦 Decision Points & Routing Logic

### RootView Decision Tree (What It Should Be)

```swift
struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var authService = AuthService()
    @StateObject private var onboardingState = OnboardingStateManager()
    @StateObject private var packManager = PackMembershipManager()
    
    var body: some View {
        Group {
            if authService.isLoading {
                LoadingView()
            } else if !authService.isAuthenticated {
                // No auth → Show auth flow
                AuthView()
            } else if onboardingState.hasInvitePending {
                // Has pending invite → Show invite onboarding
                InviteFlowController(inviteData: onboardingState.pendingInvite!)
            } else if !onboardingState.hasCompletedOnboarding {
                // No onboarding → Show normal onboarding
                OnboardingFlowController()
            } else if packManager.activePack == nil {
                // No active pack → Show pack discovery
                PackDiscoveryView()
            } else {
                // All good → Show main app
                MainTabView()
            }
        }
        .task {
            await authService.checkAuth()
            if authService.isAuthenticated {
                await onboardingState.checkStatus()
                await packManager.loadUserPacks()
            }
        }
    }
}
```

---

## 📊 Feature Status

### ✅ Complete UI (Needs Integration)
- [x] All 33 onboarding steps
- [x] All 9 invite steps
- [x] FeedView
- [x] ActiveCheckInView
- [x] VotingFullView
- [x] JailSystemView
- [x] CheckInDetailView
- [x] PackRulesView
- [x] ProfileView
- [x] SettingsView

### 🔨 Needs Building
- [ ] AuthService
- [ ] OnboardingStateManager
- [ ] PackMembershipManager
- [ ] DeepLinkRouter
- [ ] OnboardingFlowController (exists but needs fixes)
- [ ] InviteFlowController (exists but needs fixes)

### 🔗 Needs Integration
- [ ] Wire OnboardingData to backend API calls
- [ ] Wire InviteData to pack join API
- [ ] Connect auth state to RootView
- [ ] Connect onboarding state to RootView
- [ ] Handle deep links properly
- [ ] Persist user progress

---

## 🎯 Next Steps (Priority Order)

1. **Fix OnboardingFlowController & InviteFlowController errors**
   - Fix parameter mismatches
   - Ensure OnboardingData/InviteData persist

2. **Build AuthService**
   - Apple Sign In integration
   - Supabase auth state management
   - Token persistence

3. **Build OnboardingStateManager**
   - Track completion status
   - Save/load progress
   - Handle resume

4. **Update RootView logic**
   - Remove hardcoded booleans
   - Use real auth/onboarding state

5. **Build DeepLinkRouter**
   - Parse invite links
   - Route to correct flow

6. **Backend Integration**
   - Submit onboarding data
   - Join pack via invite
   - Load user profile

---

## 💡 Key Insights

**The User Should:**
1. Never see auth screen if already logged in
2. Never repeat onboarding if completed
3. Always resume where they left off
4. Be able to join via invite link seamlessly
5. See their pack feed immediately after onboarding

**The App Should:**
1. Check auth on every launch
2. Persist onboarding progress
3. Handle deep links correctly
4. Sync state with backend
5. Show appropriate loading states

---

**Last Updated:** 2025-10-28
