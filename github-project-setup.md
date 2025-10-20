# Pakkt Development - GitHub Project & Issues Setup

## GitHub Project Structure

### Project: "Pakkt Development"
**Owner:** Rinshin-Jalal
**Columns:**
1. Backlog
2. Phase 0 (Foundation)
3. Phase 1 (MVP)
4. Phase 2 (Consequences)
5. Phase 3 (Social)
6. Phase 4 (Payments)
7. Phase 5 (Polish)
8. Phase 6 (Launch)
9. Phase 7 (Growth)
10. Done

### Labels
- **Priority:** `priority:high` (red), `priority:medium` (yellow), `priority:low` (green)
- **Area:** `area:ios` (blue), `area:backend` (teal), `area:design` (pink), `area:infrastructure` (red), `area:testing` (blue), `area:marketing` (yellow)
- **Phase:** `phase:foundation` (purple), `phase:mvp` (green), `phase:consequences` (red), `phase:social` (yellow), `phase:payments` (blue), `phase:polish` (green), `phase:launch` (yellow), `phase:growth` (red)

---

## Phase 0: Foundation & Planning Issues

### Issue #1: Phase 0.1 - Complete Planning Documents and Todo Lists
**Labels:** `priority:high`, `phase:foundation`, `area:infrastructure`

**Description:**
Complete all planning documents and todo lists to establish solid project foundation.

**Tasks:**
- [ ] Review and finalize all documents in `/todos/` folder
- [ ] Create comprehensive project timeline (Weeks 1-25)
- [ ] Define success metrics for each phase
- [ ] Create risk assessment document
- [ ] Establish communication protocols (daily standups, weekly reviews)
- [ ] Set up project management tools (GitHub Projects, milestones)

**Success Criteria:**
- All planning documents reviewed and approved
- Timeline created with realistic deadlines
- Team aligned on goals and processes
- Risk mitigation strategies documented

**Assignee:** Product Manager
**Estimate:** 2 days

### Issue #2: Phase 0.2 - Set Up Development Environment
**Labels:** `priority:high`, `phase:foundation`, `area:infrastructure`

**Description:**
Configure complete development environment for iOS, backend, and infrastructure work.

**iOS Development Setup:**
- [ ] Install Xcode 15+ (latest stable)
- [ ] Install Homebrew package manager
- [ ] Install Swift CLI tools
- [ ] Configure iOS Simulator for testing
- [ ] Set up iOS development certificates

**Backend Development Setup:**
- [ ] Install Node.js 20+ LTS
- [ ] Install Wrangler CLI (`npm install -g wrangler`)
- [ ] Install Supabase CLI (`brew install supabase/tap/supabase`)
- [ ] Configure Cloudflare account and API tokens

**Development Tools:**
- [ ] Install SwiftLint for code quality
- [ ] Install SwiftFormat for code formatting
- [ ] Set up Git hooks for pre-commit checks
- [ ] Configure SSH keys for GitHub access

**Verification:**
- [ ] `xcodebuild -version` works
- [ ] `swift --version` works
- [ ] `node --version` works
- [ ] `wrangler --version` works
- [ ] `supabase --version` works

**Success Criteria:**
- All development tools installed and verified
- Local development environment fully functional
- Team members can build and run basic projects

**Assignee:** DevOps Lead
**Estimate:** 3 days

### Issue #3: Phase 0.3 - Configure Backend Infrastructure (Cloudflare + Supabase)
**Labels:** `priority:high`, `phase:foundation`, `area:infrastructure`

**Description:**
Set up Cloudflare Workers and Supabase infrastructure for production and development environments.

**Supabase Setup:**
- [ ] Create Supabase project: "pakkt-production"
- [ ] Create Supabase project: "pakkt-development"
- [ ] Configure environment variables in Xcode
- [ ] Set up database schema (all tables from technical architecture)
- [ ] Configure Row Level Security (RLS) policies
- [ ] Set up real-time subscriptions
- [ ] Configure storage buckets for avatars and photos

**Cloudflare Setup:**
- [ ] Create Cloudflare account
- [ ] Add custom domain: `api.pakkt.app`
- [ ] Configure DNS records
- [ ] Generate API tokens for Wrangler
- [ ] Set up Cloudflare R2 for image storage
- [ ] Configure CDN and caching

**Environment Configuration:**
- [ ] Set up production secrets (Stripe, APNS, etc.)
- [ ] Set up development secrets
- [ ] Configure environment-specific settings
- [ ] Test connectivity between services

**Success Criteria:**
- Both Supabase projects created and configured
- Cloudflare domain and R2 storage set up
- All environment variables configured
- Basic API connectivity verified

**Assignee:** Backend Developer
**Estimate:** 5 days

### Issue #4: Phase 0.4 - Create Design System in Figma
**Labels:** `priority:high`, `phase:foundation`, `area:design`

**Description:**
Build comprehensive design system with colors, typography, components, and design tokens.

**Color System:**
- [ ] Define foundation colors (pure black, deep gray, charcoal, etc.)
- [ ] Create neon accent colors (electric cyan, hot magenta, etc.)
- [ ] Set up semantic colors (success, error, warning, etc.)
- [ ] Create gradient system for glass effects
- [ ] Define shadow system (brutal and neon glows)

**Typography:**
- [ ] Set up SF Pro Display for headers (H1-H3)
- [ ] Configure SF Pro for body text (large, regular, small)
- [ ] Define label styles (ALL CAPS for buttons)
- [ ] Create monospace styles for numbers/timers
- [ ] Establish text hierarchy and spacing

**Component Library:**
- [ ] Design button variants (Primary, Danger, Secondary, Ghost)
- [ ] Create card components (Glass Card, Pack Card, Check-In Card)
- [ ] Build input fields (Text Field, Phone Field, Slider)
- [ ] Design navigation elements (Tab Bar, Navigation Bar)
- [ ] Create status indicators and badges

**Design Tokens:**
- [ ] Export color palette as JSON/Swift constants
- [ ] Document spacing scale (8pt grid)
- [ ] Define border radius and border width tokens
- [ ] Create component usage guidelines

**Success Criteria:**
- Complete Figma design system with all components
- Design tokens exported for developers
- Component library documented and organized
- Design system follows dark neobrutalism + glass principles

**Assignee:** UI/UX Designer
**Estimate:** 7 days

### Issue #5: Phase 0.5 - Establish CI/CD Pipeline
**Labels:** `priority:high`, `phase:foundation`, `area:infrastructure`

**Description:**
Set up automated build, test, and deployment pipelines for iOS and backend.

**GitHub Actions Setup:**
- [ ] Create workflow for iOS builds (`ios-build.yml`)
- [ ] Create workflow for backend deployment (`backend-deploy.yml`)
- [ ] Set up automated testing on pull requests
- [ ] Configure code quality checks (SwiftLint, ESLint)

**iOS CI/CD:**
- [ ] Automate SwiftLint on every PR
- [ ] Run unit tests on every commit
- [ ] Build and archive for TestFlight on merge to main
- [ ] Set up automatic TestFlight uploads

**Backend CI/CD:**
- [ ] Deploy Cloudflare Workers on merge to main
- [ ] Run TypeScript checks and tests
- [ ] Automate database migrations (if needed)
- [ ] Set up staging environment deployments

**Quality Gates:**
- [ ] Require PR reviews before merge
- [ ] Enforce code coverage minimum (70% target)
- [ ] Block merges if tests fail
- [ ] Require linear git history

**Success Criteria:**
- All CI/CD pipelines operational
- Automated testing working on PRs
- Code quality checks enforced
- Deployment to staging/production automated

**Assignee:** DevOps Engineer
**Estimate:** 4 days

### Issue #6: Phase 0.6 - Set Up Project Management (GitHub Projects)
**Labels:** `priority:medium`, `phase:foundation`, `area:infrastructure`

**Description:**
Configure GitHub Projects for comprehensive project tracking and milestone management.

**Project Setup:**
- [ ] Create "Pakkt Development" project
- [ ] Set up columns for each phase
- [ ] Configure automation rules
- [ ] Set up project templates

**Issue Organization:**
- [ ] Create detailed issues for all tasks from todo documents
- [ ] Add appropriate labels (priority, area, phase)
- [ ] Assign issues to team members
- [ ] Set up milestones for each phase

**Milestone Creation:**
- [ ] Phase 0: Foundation (Weeks 1-2)
- [ ] Phase 1: Core MVP (Weeks 3-8)
- [ ] Phase 2: Consequences (Weeks 9-12)
- [ ] Phase 3: Social (Weeks 13-16)
- [ ] Phase 4: Payments (Weeks 17-20)
- [ ] Phase 5: Polish (Weeks 21-24)
- [ ] Phase 6: Launch (Week 25)
- [ ] Phase 7: Growth (Months 2-6)

**Success Criteria:**
- GitHub project fully configured
- All issues created and organized
- Team members assigned to issues
- Milestones set with due dates

**Assignee:** Project Manager
**Estimate:** 2 days

---

## Phase 1: Core MVP Issues

### Issue #7: Phase 1.1 - Supabase Auth Integration
**Labels:** `priority:high`, `phase:mvp`, `area:backend`

**Description:**
Implement phone number authentication using Supabase Auth.

**Authentication Flow:**
- [ ] Set up Supabase Auth client in iOS app
- [ ] Create login screen with phone number input
- [ ] Implement OTP verification screen
- [ ] Handle auth state changes and persistence
- [ ] Store JWT tokens securely (Keychain)

**Error Handling:**
- [ ] Invalid phone number validation
- [ ] OTP expiration handling
- [ ] Rate limiting for OTP requests
- [ ] Network error handling

**Security:**
- [ ] Verify phone number ownership
- [ ] Implement session management
- [ ] Handle token refresh automatically
- [ ] Secure token storage

**Success Criteria:**
- Users can sign up with phone number
- OTP verification works reliably
- Auth state persists across app launches
- Secure token handling implemented

**Assignee:** iOS Developer
**Estimate:** 3 days

### Issue #8: Phase 1.2 - Onboarding Flow (5 Screens)
**Labels:** `priority:high`, `phase:mvp`, `area:ios`

**Description:**
Create comprehensive onboarding experience for new users.

**Screen 1: Welcome**
- [ ] Aggressive tagline: "SHOW UP OR PAY UP"
- [ ] Brief explanation of the concept
- [ ] "LET'S GO" CTA button

**Screen 2: Create Profile**
- [ ] Username input (unique validation)
- [ ] Display name input
- [ ] Optional avatar upload
- [ ] Optional bio (1-2 sentences)

**Screen 3: Notification Permission**
- [ ] Explain why notifications are needed
- [ ] Request UNUserNotificationCenter permission
- [ ] Handle accept/deny gracefully

**Screen 4: Create or Join Pack**
- [ ] Two options: "CREATE PACK" or "JOIN PACK"
- [ ] Pack creation: Name input
- [ ] Pack joining: Invite code input

**Screen 5: Family Controls Permission**
- [ ] Explain phone jail feature
- [ ] Request FamilyControls authorization
- [ ] Handle denial (feature becomes unavailable)

**Technical Implementation:**
- [ ] Smooth transitions between screens
- [ ] Form validation and error handling
- [ ] Skip logic for existing users
- [ ] Progress indicator

**Success Criteria:**
- Complete onboarding flow functional
- All permissions requested appropriately
- User profile created in database
- Smooth user experience

**Assignee:** iOS Developer
**Estimate:** 4 days

### Issue #9: Phase 1.3 - User Profile Creation
**Labels:** `priority:high`, `phase:mvp`, `area:backend`

**Description:**
Implement user profile creation and management in Supabase.

**Database Schema:**
- [ ] Create users table with all required fields
- [ ] Set up RLS policies for user data
- [ ] Create database functions for profile management

**API Endpoints:**
- [ ] POST `/users/profile` - Create/update profile
- [ ] GET `/auth/me` - Get current user data
- [ ] POST `/users/push-token` - Update push token

**Profile Fields:**
- [ ] id (UUID, primary key)
- [ ] phone_number (unique)
- [ ] username (unique)
- [ ] display_name
- [ ] avatar_url
- [ ] bio
- [ ] subscription_status
- [ ] Statistics fields (fines, streaks, etc.)

**Success Criteria:**
- User profiles created successfully
- Profile data stored securely
- API endpoints working correctly
- RLS policies protecting user data

**Assignee:** Backend Developer
**Estimate:** 2 days

### Issue #10: Phase 1.4 - Push Notification Permissions
**Labels:** `priority:high`, `phase:mvp`, `area:ios`

**Description:**
Implement push notification setup and token management.

**Permission Request:**
- [ ] Request notification permission on app launch
- [ ] Handle user responses (granted, denied, not determined)
- [ ] Store permission status locally

**Token Management:**
- [ ] Register for remote notifications
- [ ] Receive device token from APNS
- [ ] Send token to backend for storage
- [ ] Update token when it changes

**Notification Types:**
- [ ] Check-in reminders (30 min before goal time)
- [ ] Fine voting notifications
- [ ] Jail start/end notifications
- [ ] Pack activity notifications

**Success Criteria:**
- Push notification permission requested
- Device tokens stored in database
- Basic notification infrastructure working
- Notifications enabled for key features

**Assignee:** iOS Developer
**Estimate:** 2 days

---

## Phase 1: Packs & Social Core Issues

### Issue #11: Phase 1.5 - Create/Join Pack Flow
**Labels:** `priority:high`, `phase:mvp`, `area:ios`

**Description:**
Implement pack creation and joining functionality.

**Pack Creation:**
- [ ] Create pack screen with name input
- [ ] Generate unique invite code
- [ ] Set default pack settings (fine amount, jail duration)
- [ ] Add creator as admin member

**Pack Joining:**
- [ ] Join pack screen with invite code input
- [ ] Validate invite code with API
- [ ] Show pack preview before joining
- [ ] Handle member limit validation

**Pack Management:**
- [ ] Pack list view showing user's packs
- [ ] Pack detail view with member grid
- [ ] Basic pack settings (name, description)
- [ ] Member management (admin only)

**Success Criteria:**
- Users can create new packs
- Users can join packs with invite codes
- Pack data displays correctly
- Member management works

**Assignee:** iOS Developer
**Estimate:** 4 days

### Issue #12: Phase 1.6 - Pack Member Management
**Labels:** `priority:high`, `phase:mvp`, `area:backend`

**Description:**
Implement pack membership and member management system.

**Database Schema:**
- [ ] Create pack_members table
- [ ] Set up foreign key relationships
- [ ] Configure RLS policies for pack access

**API Endpoints:**
- [ ] GET `/packs` - List user's packs
- [ ] GET `/packs/:id` - Get pack details with members
- [ ] POST `/packs/join` - Join pack with invite code
- [ ] DELETE `/packs/:id/members/:userId` - Remove member (admin)

**Member Roles:**
- [ ] Admin: Can manage pack settings and members
- [ ] Member: Standard pack participation
- [ ] Implement role-based permissions

**Success Criteria:**
- Pack membership system functional
- Role-based access control working
- API endpoints secure and performant
- Member management UI complete

**Assignee:** Backend Developer
**Estimate:** 3 days

### Issue #13: Phase 1.7 - Pack Settings and Rules
**Labels:** `priority:medium`, `phase:mvp`, `area:ios`

**Description:**
Create pack settings interface for configuring rules and preferences.

**Pack Settings:**
- [ ] Edit pack name and description
- [ ] Change pack avatar
- [ ] Set default fine amount ($1-$20)
- [ ] Set default jail duration (15-60 min)
- [ ] Configure min votes for fine activation

**Pack Rules Display:**
- [ ] Show current pack rules to members
- [ ] Explain voting mechanics
- [ ] Display pack statistics

**Admin Controls:**
- [ ] Transfer admin role to another member
- [ ] Delete pack (with confirmation)
- [ ] Manage member permissions

**Success Criteria:**
- Pack settings fully configurable
- Rules clearly communicated to members
- Admin controls functional
- Settings persist correctly

**Assignee:** iOS Developer
**Estimate:** 3 days

### Issue #14: Phase 1.8 - Invite System with Deep Links
**Labels:** `priority:medium`, `phase:mvp`, `area:ios`

**Description:**
Implement pack invitation system with shareable links and deep linking.

**Invite Code Generation:**
- [ ] Generate unique 6-character invite codes
- [ ] Store codes in database
- [ ] Ensure uniqueness across all packs

**Sharing Options:**
- [ ] Share via Messages app
- [ ] Share via social media (Instagram, Snapchat)
- [ ] Copy invite link to clipboard
- [ ] Generate QR codes for invite codes

**Deep Link Handling:**
- [ ] Configure URL scheme: `pakkt://pack/join?code=ABC123`
- [ ] Handle incoming deep links
- [ ] Parse invite codes from URLs
- [ ] Navigate to join pack flow

**Success Criteria:**
- Invite codes generate uniquely
- Sharing options work on all platforms
- Deep links open app correctly
- Join flow works from external links

**Assignee:** iOS Developer
**Estimate:** 3 days

---

## Phase 1: Goals & Check-Ins Issues

### Issue #15: Phase 1.9 - Goal Creation Interface
**Labels:** `priority:high`, `phase:mvp`, `area:ios`

**Description:**
Build goal creation UI with all required configuration options.

**Goal Creation Form:**
- [ ] Goal title input (required)
- [ ] Goal description (optional)
- [ ] Check-in time picker (HH:MM format)
- [ ] Fine amount slider ($1-$20, pack default)
- [ ] Jail duration picker (15, 30, 45, 60 min)
- [ ] Photo requirement toggle

**Validation:**
- [ ] Required fields validation
- [ ] Time format validation
- [ ] Reasonable limits on amounts/durations

**Pack Integration:**
- [ ] Associate goal with specific pack
- [ ] Inherit pack default settings
- [ ] Verify user is pack member

**Success Criteria:**
- Goals create successfully with all options
- Form validation works correctly
- Goals appear in pack and user lists
- Settings save to database

**Assignee:** iOS Developer
**Estimate:** 3 days

### Issue #16: Phase 1.10 - Daily Check-In Flow with Timer
**Labels:** `priority:high`, `phase:mvp`, `area:ios`

**Description:**
Implement the core check-in experience with photo upload and timer.

**Check-In Flow:**
- [ ] Large goal title display
- [ ] Countdown timer (30 min window)
- [ ] Camera button for photo capture
- [ ] Photo preview with retake option
- [ ] Caption input (optional)
- [ ] Submit button (neon green)

**Timer Logic:**
- [ ] Start timer when check-in begins
- [ ] Show time remaining prominently
- [ ] Handle timer pause on app background
- [ ] Auto-submit or mark late after timer expires

**Photo Handling:**
- [ ] Access device camera
- [ ] Compress images for upload
- [ ] Store in Cloudflare R2
- [ ] Handle upload failures gracefully

**Success Criteria:**
- Check-in flow works end-to-end
- Timer functions correctly
- Photos upload successfully
- Late check-ins handled properly

**Assignee:** iOS Developer
**Estimate:** 4 days

### Issue #17: Phase 1.11 - Photo Upload for Check-Ins
**Labels:** `priority:high`, `phase:mvp`, `area:backend`

**Description:**
Implement photo upload functionality for check-ins using Cloudflare R2.

**Image Upload API:**
- [ ] POST `/upload/checkin` endpoint
- [ ] Accept multipart/form-data
- [ ] Validate file type (jpg, png, heic)
- [ ] Validate file size (max 5MB)
- [ ] Upload to R2 bucket

**Image Processing:**
- [ ] Resize images to standard dimensions
- [ ] Compress for web delivery
- [ ] Generate public URLs
- [ ] Set appropriate cache headers

**Security:**
- [ ] Authenticate upload requests
- [ ] Associate images with user/goal
- [ ] Prevent unauthorized access
- [ ] Implement rate limiting

**Success Criteria:**
- Photos upload successfully to R2
- Images accessible via public URLs
- Upload errors handled gracefully
- Reasonable file size limits enforced

**Assignee:** Backend Developer
**Estimate:** 2 days

### Issue #18: Phase 1.12 - Streak Tracking System
**Labels:** `priority:high`, `phase:mvp`, `area:backend`

**Description:**
Implement streak calculation and tracking across goals and users.

**Streak Logic:**
- [ ] Calculate consecutive check-ins
- [ ] Reset streak on missed day
- [ ] Handle time zones correctly
- [ ] Update streaks in real-time

**Database Updates:**
- [ ] Add streak fields to goals and users
- [ ] Create functions to calculate streaks
- [ ] Update streaks on successful check-ins
- [ ] Handle streak resets

**API Integration:**
- [ ] Return streak data in check-in responses
- [ ] Include streaks in user profiles
- [ ] Update streaks in real-time feeds

**Success Criteria:**
- Streaks calculate accurately
- Streak resets work correctly
- UI displays current and longest streaks
- Streaks update in real-time

**Assignee:** Backend Developer
**Estimate:** 3 days

### Issue #19: Phase 1.13 - Check-In Notifications
**Labels:** `priority:medium`, `phase:mvp`, `area:backend`

**Description:**
Implement push notifications for check-in reminders and deadlines.

**Reminder System:**
- [ ] Schedule notifications 30 min before check-in time
- [ ] Custom notification text per goal
- [ ] Handle multiple goals per day
- [ ] Respect user notification preferences

**APNS Integration:**
- [ ] Set up APNS credentials in Supabase
- [ ] Configure notification templates
- [ ] Handle delivery failures
- [ ] Support silent notifications for background tasks

**Notification Types:**
- [ ] Check-in reminder: "Time to check in for GYM!"
- [ ] Late warning: "Check-in window closing soon"
- [ ] Success confirmation: "Check-in recorded!"

**Success Criteria:**
- Check-in reminders arrive on time
- Notifications respect user settings
- APNS integration working reliably
- Notification delivery tracked

**Assignee:** Backend Developer
**Estimate:** 3 days

---

## Phase 2: Consequences System Issues

### Issue #20: Phase 2.1 - Democratic Voting for Fines
**Labels:** `priority:high`, `phase:consequences`, `area:ios`

**Description:**
Implement fine voting system where pack members vote on whether to activate fines.

**Fine Notification:**
- [ ] Modal appears when fine is triggered
- [ ] Shows fine amount and reason
- [ ] Displays voting options (Activate/Slide)
- [ ] Shows current vote count

**Voting Interface:**
- [ ] "ACTIVATE FINE" button (red/magenta)
- [ ] "LET IT SLIDE" button (gray)
- [ ] Vote count updates in real-time
- [ ] Timer shows voting deadline

**Vote Tracking:**
- [ ] Record individual votes in database
- [ ] Update vote counts live
- [ ] Handle vote changes (allow changing vote?)
- [ ] Notify when threshold reached

**Success Criteria:**
- Fine voting works smoothly
- Real-time vote updates
- Voting deadline enforced
- Fine activation threshold working

**Assignee:** iOS Developer
**Estimate:** 4 days

### Issue #21: Phase 2.2 - Fine Amount Configuration
**Labels:** `priority:medium`, `phase:consequences`, `area:ios`

**Description:**
Allow packs to configure fine amounts and voting thresholds.

**Pack-Level Settings:**
- [ ] Default fine amount ($1-$20 range)
- [ ] Minimum votes required for activation
- [ ] Fine escalation options (optional)

**Goal-Level Overrides:**
- [ ] Allow goals to override pack defaults
- [ ] Fine amount per goal
- [ ] Different amounts for different goals

**Fine Display:**
- [ ] Show configured amounts in pack settings
- [ ] Display amounts in fine notifications
- [ ] Explain voting mechanics clearly

**Success Criteria:**
- Fine amounts configurable at pack level
- Goal-level overrides working
- Settings persist correctly
- UI clearly shows fine amounts

**Assignee:** iOS Developer
**Estimate:** 2 days

### Issue #22: Phase 2.3 - Fine Notification and Timer
**Labels:** `priority:high`, `phase:consequences`, `area:backend`

**Description:**
Implement fine creation, voting timer, and notification system.

**Fine Creation:**
- [ ] Trigger fines for missed check-ins
- [ ] Create fine records in database
- [ ] Set voting deadline (e.g., 2 hours)
- [ ] Send notifications to pack members

**Voting Timer:**
- [ ] Track voting period duration
- [ ] Auto-activate fine if threshold met
- [ ] Handle voting deadline expiration
- [ ] Update fine status accordingly

**Notification System:**
- [ ] Push notifications to all pack members
- [ ] In-app notifications for active fines
- [ ] Email notifications (optional)

**Success Criteria:**
- Fines created automatically for missed check-ins
- Voting timer works correctly
- Pack members notified immediately
- Fine activation threshold enforced

**Assignee:** Backend Developer
**Estimate:** 3 days

### Issue #23: Phase 2.4 - Honor System Payment Tracking
**Labels:** `priority:medium`, `phase:consequences`, `area:ios`

**Description:**
Implement basic payment tracking using honor system for MVP.

**Payment Interface:**
- [ ] "PAY NOW" button in fine details
- [ ] Payment method selection (Honor System, Venmo, Cash App)
- [ ] Mark as paid functionality
- [ ] Payment confirmation

**Honor System:**
- [ ] "I paid" button for fined user
- [ ] Notify pack members of payment
- [ ] Allow pack members to dispute payments
- [ ] Track payment status

**Payment History:**
- [ ] List of all fines with payment status
- [ ] Filter by paid/unpaid
- [ ] Show payment method used

**Success Criteria:**
- Honor system payment tracking works
- Payment status updates correctly
- Pack members can verify payments
- Payment history accessible

**Assignee:** iOS Developer
**Estimate:** 3 days

---

## Phase 2: Phone Jail MVP Issues

### Issue #24: Phase 2.5 - iOS Screen Time API Entitlement Request
**Labels:** `priority:high`, `phase:consequences`, `area:infrastructure`

**Description:**
Request and configure Family Controls entitlement for phone jail feature.

**Entitlement Request:**
- [ ] Go to Apple Developer portal
- [ ] Submit Family Controls entitlement request
- [ ] Provide detailed justification (accountability app)
- [ ] Reference similar apps (Opal, Freedom)
- [ ] Explain democratic voting mechanism

**Xcode Configuration:**
- [ ] Add Family Controls capability
- [ ] Configure entitlement in App ID
- [ ] Import FamilyControls framework
- [ ] Request authorization in app

**Timeline Planning:**
- [ ] Start process Week 1 (can take 2-4 weeks)
- [ ] Plan for rejections and resubmissions
- [ ] Have backup plan if entitlement denied

**Success Criteria:**
- Entitlement request submitted
- Xcode project configured for Family Controls
- Authorization request implemented
- Backup plan documented

**Assignee:** iOS Developer
**Estimate:** 2 days

### Issue #25: Phase 2.6 - Family Controls Framework Integration
**Labels:** `priority:high`, `phase:consequences`, `area:ios`

**Description:**
Integrate Family Controls framework for app blocking functionality.

**Authorization Request:**
- [ ] Request FamilyControls authorization
- [ ] Handle user permission responses
- [ ] Store authorization status
- [ ] Graceful degradation if denied

**App Selection:**
- [ ] Use FamilyActivityPicker for app selection
- [ ] Allow users to choose apps to block
- [ ] Store selected apps in jail session
- [ ] Validate app bundle IDs

**Blocking Implementation:**
- [ ] Use DeviceActivityMonitor for enforcement
- [ ] Apply ShieldConfiguration during jail
- [ ] Block selected apps completely
- [ ] Show custom blocking screen

**Success Criteria:**
- Family Controls authorization works
- App selection interface functional
- Apps actually blocked during jail
- Blocking screen displays correctly

**Assignee:** iOS Developer
**Estimate:** 5 days

### Issue #26: Phase 2.7 - App Blocking Interface
**Labels:** `priority:high`, `phase:consequences`, `area:ios`

**Description:**
Create the phone jail interface that displays during active jail sessions.

**Jail Screen Design:**
- [ ] Full-screen takeover interface
- [ ] Large countdown timer (center)
- [ ] "YOU'RE IN JAIL" header
- [ ] List of blocked apps (grayed out)
- [ ] Current time display

**Timer Functionality:**
- [ ] Real-time countdown display
- [ ] Handle timer pause when app backgrounds
- [ ] Sync timer with backend
- [ ] Prevent timer manipulation

**User Interaction:**
- [ ] "BREAK JAIL" button (pay 2x fine)
- [ ] Show break fine amount
- [ ] Confirm break action
- [ ] Handle jail completion

**Success Criteria:**
- Jail screen displays correctly
- Timer counts down accurately
- App blocking enforced
- Break jail functionality works

**Assignee:** iOS Developer
**Estimate:** 4 days

### Issue #27: Phase 2.8 - Jail Timer with Pause Detection
**Labels:** `priority:high`, `phase:consequences`, `area:backend`

**Description:**
Implement jail timer logic with pause detection and backend synchronization.

**Timer Logic:**
- [ ] Start timer when jail begins
- [ ] Track scheduled end time
- [ ] Handle timer pause on app background
- [ ] Resume timer when app foregrounds

**Backend Synchronization:**
- [ ] Store jail sessions in database
- [ ] Sync timer state across devices
- [ ] Prevent timer manipulation
- [ ] Handle server time vs device time

**Pause Detection:**
- [ ] Detect when app goes to background
- [ ] Pause timer during background time
- [ ] Resume when app returns to foreground
- [ ] Notify user of pause

**Success Criteria:**
- Timer pauses correctly when app backgrounds
- Timer state syncs with backend
- No way to cheat the timer
- Jail duration enforced accurately

**Assignee:** Backend Developer
**Estimate:** 4 days

### Issue #28: Phase 2.9 - Break Jail 2x Fine Option
**Labels:** `priority:medium`, `phase:consequences`, `area:backend`

**Description:**
Implement break jail functionality with 2x fine penalty.

**Break Logic:**
- [ ] Calculate 2x fine amount
- [ ] Create new fine record
- [ ] End jail session immediately
- [ ] Unblock apps instantly

**Fine Creation:**
- [ ] Associate break fine with original goal
- [ ] Mark fine as active (no voting needed)
- [ ] Set payment deadline
- [ ] Notify pack members

**Jail Termination:**
- [ ] Update jail status to 'broken'
- [ ] Record break timestamp
- [ ] Remove app blocks
- [ ] Update user statistics

**Success Criteria:**
- Break jail creates 2x fine correctly
- Apps unblocked immediately
- Jail session ends properly
- Fine appears in user's fine list

**Assignee:** Backend Developer
**Estimate:** 2 days

### Issue #29: Phase 2.10 - Jail Notification System
**Labels:** `priority:medium`, `phase:consequences`, `area:backend`

**Description:**
Implement notifications for jail start, progress, and completion.

**Jail Start Notifications:**
- [ ] Notify jailed user when jail begins
- [ ] Notify pack members of new jail
- [ ] Include jail duration and blocked apps

**Progress Notifications:**
- [ ] Optional: Halfway point notification
- [ ] Low battery warning during jail
- [ ] App background warnings

**Completion Notifications:**
- [ ] Success notification when jail completes
- [ ] Share achievement prompt
- [ ] Update pack members of completion

**Break Notifications:**
- [ ] Notify pack when user breaks jail
- [ ] Include break fine amount
- [ ] Shame messaging (light-hearted)

**Success Criteria:**
- All jail events trigger appropriate notifications
- Notifications arrive reliably
- Notification content is engaging
- Users can disable non-essential notifications

**Assignee:** Backend Developer
**Estimate:** 3 days

---

## Phase 3: Social & Engagement Issues

### Issue #30: Phase 3.1 - BeReal-Style Main Feed
**Labels:** `priority:high`, `phase:social`, `area:ios`

**Description:**
Create the main social feed showing check-ins from all user's packs.

**Feed Layout:**
- [ ] Vertical scrollable list
- [ ] Each check-in as a card
- [ ] User avatar + username + timestamp
- [ ] Check-in photo (if provided)
- [ ] Caption text
- [ ] Streak badge if milestone

**Real-time Updates:**
- [ ] Subscribe to Supabase real-time
- [ ] New check-ins appear instantly
- [ ] Update reaction counts live
- [ ] Handle connection drops gracefully

**Feed Features:**
- [ ] Pull to refresh
- [ ] Infinite scroll (pagination)
- [ ] Empty state for no check-ins
- [ ] Loading states and error handling

**Success Criteria:**
- Feed loads check-ins from all packs
- Real-time updates work smoothly
- Scrolling performance optimized
- Empty states handled gracefully

**Assignee:** iOS Developer
**Estimate:** 5 days

### Issue #31: Phase 3.2 - React System (Emoji Reactions)
**Labels:** `priority:medium`, `phase:social`, `area:ios`

**Description:**
Implement emoji reaction system for check-ins and other content.

**Reaction Interface:**
- [ ] Reaction bar below each check-in
- [ ] Popular emojis: 💀 🔥 💪 👑 😂 💸
- [ ] Tap emoji to add/remove reaction
- [ ] Show reaction counts

**Real-time Reactions:**
- [ ] Update counts instantly
- [ ] Animate reaction additions
- [ ] Handle multiple reactions per user
- [ ] Sync across all devices

**Reaction Types:**
- [ ] Check-in reactions
- [ ] Fine reactions
- [ ] Jail reactions
- [ ] Comment reactions

**Success Criteria:**
- Reactions add/remove smoothly
- Counts update in real-time
- Multiple reactions supported
- UI animations engaging

**Assignee:** iOS Developer
**Estimate:** 3 days

### Issue #32: Phase 3.3 - Comments on Check-Ins
**Labels:** `priority:medium`, `phase:social`, `area:ios`

**Description:**
Add commenting functionality to check-ins and other content.

**Comment Interface:**
- [ ] Comment button with count
- [ ] Expand to show comment thread
- [ ] Text input at bottom
- [ ] Send button

**Comment Display:**
- [ ] Avatar + username + timestamp
- [ ] Comment text
- [ ] Nested replies (optional)
- [ ] Like/reaction on comments

**Real-time Comments:**
- [ ] New comments appear instantly
- [ ] Typing indicators (optional)
- [ ] Handle deleted comments
- [ ] Pagination for long threads

**Success Criteria:**
- Comments post successfully
- Real-time comment updates
- Comment threads display correctly
- Moderation tools available

**Assignee:** iOS Developer
**Estimate:** 4 days

### Issue #33: Phase 3.4 - Trash Talk Interface
**Labels:** `priority:low`, `phase:social`, `area:ios`

**Description:**
Create engaging trash talk features for social interaction.

**Trash Talk Features:**
- [ ] Pre-written trash talk messages
- [ ] Context-aware suggestions
- [ ] Send via reactions or comments
- [ ] Pack-specific trash talk culture

**Moderation:**
- [ ] Basic content filtering
- [ ] Report inappropriate content
- [ ] Admin moderation tools

**Success Criteria:**
- Trash talk features add engagement
- Content remains appropriate
- Features enhance pack culture
- Moderation system functional

**Assignee:** iOS Developer
**Estimate:** 3 days

### Issue #34: Phase 3.5 - Streak Celebrations
**Labels:** `priority:medium`, `phase:social`, `area:ios`

**Description:**
Implement celebration features for streak milestones.

**Milestone Detection:**
- [ ] Track streak achievements (7, 30, 100 days)
- [ ] Trigger celebrations automatically
- [ ] Notify pack members of milestones

**Celebration UI:**
- [ ] Confetti animations
- [ ] Special badge unlocks
- [ ] Share to social media prompts
- [ ] Pack-wide congratulations

**Streak Features:**
- [ ] Current streak display
- [ ] Longest streak record
- [ ] Streak freeze options (future)
- [ ] Streak recovery mechanics

**Success Criteria:**
- Milestones celebrated engagingly
- Streaks prominently displayed
- Sharing options available
- Celebrations feel rewarding

**Assignee:** iOS Developer
**Estimate:** 3 days

### Issue #35: Phase 3.6 - Activity Notifications
**Labels:** `priority:medium`, `phase:social`, `area:backend`

**Description:**
Implement comprehensive activity notification system.

**Notification Types:**
- [ ] New check-in from pack member
- [ ] Fine voted on/activated
- [ ] Jail started/completed/broken
- [ ] New pack member joined
- [ ] Goal created in pack
- [ ] Reaction received on your content

**Notification Management:**
- [ ] In-app notification center
- [ ] Push notification preferences
- [ ] Notification settings per pack
- [ ] Mute options for noisy packs

**Real-time Delivery:**
- [ ] Instant push notifications
- [ ] In-app badge updates
- [ ] Notification history
- [ ] Mark as read functionality

**Success Criteria:**
- All important activities notified
- Notification preferences respected
- Push notifications reliable
- In-app notification center functional

**Assignee:** Backend Developer
**Estimate:** 4 days

---

## Phase 3: Gamification & Stats Issues

### Issue #36: Phase 3.7 - Personal Stats Dashboard
**Labels:** `priority:medium`, `phase:social`, `area:ios`

**Description:**
Create comprehensive personal statistics dashboard.

**Stats Categories:**
- [ ] Current streak (fire emoji)
- [ ] Longest streak ever
- [ ] Total check-ins completed
- [ ] Total fines paid/received
- [ ] Total jail time served
- [ ] Goals completed this month

**Progress Visualization:**
- [ ] Charts and graphs
- [ ] Monthly/yearly trends
- [ ] Comparison to pack averages
- [ ] Achievement progress bars

**Dashboard Layout:**
- [ ] Grid of stat cards
- [ ] Time period filters
- [ ] Share stats button
- [ ] Export data option

**Success Criteria:**
- All personal stats displayed
- Data accurate and up-to-date
- Visualizations engaging
- Share functionality works

**Assignee:** iOS Developer
**Estimate:** 4 days

### Issue #37: Phase 3.8 - Pack Leaderboards
**Labels:** `priority:medium`, `phase:social`, `area:ios`

**Description:**
Implement pack-wide leaderboards and competitions.

**Leaderboard Types:**
- [ ] Current streak leaderboard
- [ ] Total check-ins leaderboard
- [ ] Fines paid leaderboard
- [ ] Jail time leaderboard

**Time Periods:**
- [ ] This week
- [ ] This month
- [ ] All time
- [ ] Custom date ranges

**Display Features:**
- [ ] Top 3 podium display
- [ ] Full ranked list
- [ ] User rank highlighting
- [ ] Avatar and username display

**Success Criteria:**
- Leaderboards update accurately
- Multiple time periods supported
- Rankings display correctly
- Encourages healthy competition

**Assignee:** iOS Developer
**Estimate:** 3 days

### Issue #38: Phase 3.9 - Achievement System
**Labels:** `priority:low`, `phase:social`, `area:backend`

**Description:**
Create achievement/badge system for user engagement.

**Achievement Types:**
- [ ] Streak achievements (7, 30, 100, 365 days)
- [ ] Consistency achievements (check-in every day for a month)
- [ ] Social achievements (100 reactions received)
- [ ] Accountability achievements (survive 10 jails)
- [ ] Pack achievements (bring in 5 new members)

**Achievement Logic:**
- [ ] Automatic detection and awarding
- [ ] Progress tracking toward achievements
- [ ] Notification when earned
- [ ] Display in profile

**UI Integration:**
- [ ] Achievement badges in profile
- [ ] Progress indicators
- [ ] Share achievements
- [ ] Achievement history

**Success Criteria:**
- Achievements award automatically
- Progress tracking works
- UI displays achievements attractively
- Encourages long-term engagement

**Assignee:** Backend Developer
**Estimate:** 4 days

---

## Phase 4: Payments & Monetization Issues

### Issue #39: Phase 4.1 - RevenueCat Integration
**Labels:** `priority:high`, `phase:payments`, `area:ios`

**Description:**
Integrate RevenueCat for subscription management.

**RevenueCat Setup:**
- [ ] Create RevenueCat account
- [ ] Configure iOS app
- [ ] Set up products (Weekly $4, Annual $49)
- [ ] Configure 3-day free trial

**SDK Integration:**
- [ ] Install RevenueCat SDK
- [ ] Initialize in AppDelegate
- [ ] Configure API key
- [ ] Set up entitlements

**Subscription Management:**
- [ ] Purchase flow implementation
- [ ] Restore purchases
- [ ] Subscription status checking
- [ ] Handle renewals and cancellations

**Success Criteria:**
- Subscription purchases work in sandbox
- Free trial activates correctly
- Subscription status syncs with app
- Restore purchases functional

**Assignee:** iOS Developer
**Estimate:** 4 days

### Issue #40: Phase 4.2 - Paywall Design (Aggressive Value Prop)
**Labels:** `priority:high`, `phase:payments`, `area:ios`

**Description:**
Create compelling paywall that clearly communicates value.

**Paywall Layout:**
- [ ] Aggressive headline: "UNLOCK FULL PAKKT"
- [ ] Feature benefits list (3-5 bullets)
- [ ] Pricing options (Annual vs Weekly)
- [ ] Savings calculation ("Save $159/year")
- [ ] Social proof (optional)

**Pricing Display:**
- [ ] Annual: $49/year (most prominent)
- [ ] Weekly: $4/week (secondary)
- [ ] Clear free trial messaging
- [ ] Terms and restore links

**Trigger Points:**
- [ ] After 3 check-ins (trial limit)
- [ ] When trying to create 2nd pack
- [ ] When accessing phone jail
- [ ] Manual access from settings

**Success Criteria:**
- Paywall design aggressive and clear
- Value proposition compelling
- Conversion rate meets targets
- Legal compliance maintained

**Assignee:** iOS Developer
**Estimate:** 3 days

### Issue #41: Phase 4.3 - 3-Day Free Trial Flow
**Labels:** `priority:high`, `phase:payments`, `area:ios`

**Description:**
Implement free trial experience and conversion flow.

**Trial Logic:**
- [ ] Start 3-day timer on subscription start
- [ ] Track trial usage and engagement
- [ ] Show trial status in app
- [ ] Automatic conversion or cancellation

**Trial Experience:**
- [ ] Full feature access during trial
- [ ] Trial progress indicator
- [ ] Gentle reminders as trial ends
- [ ] Clear upgrade prompts

**Conversion Optimization:**
- [ ] Show value during trial
- [ ] Highlight premium features
- [ ] Offer discount for immediate conversion
- [ ] Explain what happens if trial ends

**Success Criteria:**
- 3-day trial works correctly
- Trial conversion rate >10%
- Users understand trial limits
- Smooth transition to paid

**Assignee:** iOS Developer
**Estimate:** 3 days

### Issue #42: Phase 4.4 - Subscription Status Throughout App
**Labels:** `priority:high`, `phase:payments`, `area:ios`

**Description:**
Integrate subscription status checks throughout the app.

**Feature Gating:**
- [ ] Phone jail requires subscription
- [ ] Multiple packs require subscription
- [ ] Advanced analytics require subscription
- [ ] Premium features clearly marked

**Status Display:**
- [ ] Show subscription status in settings
- [ ] Display trial countdown
- [ ] Manage subscription button
- [ ] Renewal date display

**Graceful Degradation:**
- [ ] Clear messaging for locked features
- [ ] Easy upgrade path
- [ ] No disruption to free features

**Success Criteria:**
- Subscription status always accurate
- Feature gating works correctly
- Upgrade prompts not annoying
- Free users have good experience

**Assignee:** iOS Developer
**Estimate:** 3 days

---

## Phase 4: Real Money Fines Issues

### Issue #43: Phase 4.5 - Stripe Connect Integration
**Labels:** `priority:medium`, `phase:payments`, `area:backend`

**Description:**
Set up Stripe Connect for real money fine processing.

**Stripe Setup:**
- [ ] Create Stripe account
- [ ] Enable Connect for platforms
- [ ] Configure webhook endpoints
- [ ] Set up test and production keys

**Connect Integration:**
- [ ] User onboarding for Stripe Connect
- [ ] Bank account linking
- [ ] Identity verification
- [ ] Payout scheduling

**API Implementation:**
- [ ] Charge fines to user cards
- [ ] Transfer to pack pool
- [ ] Handle failed payments
- [ ] Refund processing

**Success Criteria:**
- Stripe Connect accounts creatable
- Payment processing works
- Funds transfer correctly
- Error handling robust

**Assignee:** Backend Developer
**Estimate:** 5 days

### Issue #44: Phase 4.6 - Venmo/Cash App Linking
**Labels:** `priority:medium`, `phase:payments`, `area:ios`

**Description:**
Implement external payment app integration for fines.

**Payment Options:**
- [ ] Venmo username linking
- [ ] Cash App $Cashtag linking
- [ ] PayPal (optional)
- [ ] Bank transfer (fallback)

**Integration:**
- [ ] Deep links to payment apps
- [ ] Pre-filled payment amounts
- [ ] Payment confirmation tracking
- [ ] Receipt generation

**Honor System Fallback:**
- [ ] Mark as paid functionality
- [ ] Pack member verification
- [ ] Dispute resolution

**Success Criteria:**
- External payment apps integrated
- Payment links work correctly
- Honor system still available
- Payment tracking functional

**Assignee:** iOS Developer
**Estimate:** 4 days

### Issue #45: Phase 4.7 - Automatic Fine Collection
**Labels:** `priority:medium`, `phase:payments`, `area:backend`

**Description:**
Implement automatic fine collection and pack pool management.

**Collection Logic:**
- [ ] Auto-charge when fine activates
- [ ] Handle payment failures gracefully
- [ ] Retry failed payments
- [ ] Send payment reminders

**Pack Pool:**
- [ ] Aggregate fines into pack pool
- [ ] Track pool balance
- [ ] Distribute to members or save
- [ ] Pool management interface

**Payout System:**
- [ ] Scheduled payouts to members
- [ ] Stripe Connect transfers
- [ ] Payout history and tracking
- [ ] Tax reporting

**Success Criteria:**
- Fines collected automatically
- Pack pools managed correctly
- Payouts processed reliably
- Financial records accurate

**Assignee:** Backend Developer
**Estimate:** 5 days

---

## Phase 5: Polish & Launch Prep Issues

### Issue #46: Phase 5.1 - App Store Screenshots (8 Required)
**Labels:** `priority:high`, `phase:polish`, `area:design`

**Description:**
Create 8 App Store screenshots showcasing app features.

**Screenshot Content:**
1. **Feed**: Check-in feed with reactions
2. **Phone Jail**: Jail countdown with blocked apps
3. **Pack View**: Member grid and pack stats
4. **Check-In**: Camera interface with timer
5. **Fine Voting**: Voting interface with amounts
6. **Streak Stats**: Achievement display
7. **Paywall**: Subscription options
8. **Profile**: User stats and achievements

**Design Requirements:**
- [ ] 1284×2778px (iPhone 14 Pro Max)
- [ ] Dark theme throughout
- [ ] Neon accents and glass effects
- [ ] Aggressive, compelling copy overlays
- [ ] High-quality mockup data

**Export Requirements:**
- [ ] All required iPhone sizes
- [ ] PNG format with transparency
- [ ] Optimized file sizes

**Success Criteria:**
- 8 screenshots completed and exported
- All sizes generated automatically
- Copy is aggressive and compelling
- Screenshots load fast in App Store

**Assignee:** UI/UX Designer
**Estimate:** 3 days

### Issue #47: Phase 5.2 - App Preview Video (30 seconds)
**Labels:** `priority:high`, `phase:polish`, `area:marketing`

**Description:**
Create engaging 30-second app preview video for App Store.

**Video Structure:**
- [ ] 0-5s: Hook with phone jail demo
- [ ] 5-10s: Check-in flow showcase
- [ ] 10-15s: Fine voting demonstration
- [ ] 15-20s: Social feed and reactions
- [ ] 20-25s: Stats and achievements
- [ ] 25-30s: Call-to-action and pricing

**Production Requirements:**
- [ ] Fast-paced editing
- [ ] Aggressive music and sound effects
- [ ] Clear voiceover or text overlays
- [ ] High-quality screen recordings
- [ ] Professional color grading

**Technical Specs:**
- [ ] H.264 codec
- [ ] 1080p resolution
- [ ] 30 FPS
- [ ] Under 500MB file size

**Success Criteria:**
- Video demonstrates core value prop
- Production quality is high
- Length exactly 30 seconds
- File meets App Store requirements

**Assignee:** Video Producer
**Estimate:** 4 days

### Issue #48: Phase 5.3 - App Store Description Copy
**Labels:** `priority:high`, `phase:polish`, `area:marketing`

**Description:**
Write compelling App Store description and metadata.

**App Information:**
- [ ] Name: "Pakkt: Social Accountability"
- [ ] Subtitle: "Show Up or Pay Up"
- [ ] Keywords: accountability, habits, goals, friends, social, productivity, fines, consequences, gym, streak, pack, group, challenge

**Description (4000 chars):**
- [ ] Aggressive, no-BS copy
- [ ] Highlight phone jail as killer feature
- [ ] Explain real consequences clearly
- [ ] Include pricing information
- [ ] End with strong call-to-action

**Review Information:**
- [ ] Detailed Family Controls justification
- [ ] Demo account credentials
- [ ] Step-by-step testing instructions

**Success Criteria:**
- Description compelling and clear
- Keywords optimized for discovery
- Review notes comprehensive
- Legal requirements met

**Assignee:** Copywriter
**Estimate:** 2 days

### Issue #49: Phase 5.4 - Privacy Policy & Terms of Service
**Labels:** `priority:high`, `phase:polish`, `area:legal`

**Description:**
Create legally compliant privacy policy and terms of service.

**Privacy Policy Requirements:**
- [ ] Data collection practices
- [ ] How data is used and stored
- [ ] Third-party services (Supabase, Stripe, etc.)
- [ ] User rights (data export, deletion)
- [ ] COPPA compliance (under 13)
- [ ] Contact information

**Terms of Service:**
- [ ] User responsibilities
- [ ] Fine payment terms
- [ ] Phone jail disclaimers
- [ ] Account termination conditions
- [ ] Dispute resolution
- [ ] Limitation of liability

**Hosting:**
- [ ] Publish on pakkt.app/privacy
- [ ] Publish on pakkt.app/terms
- [ ] Link in app settings and App Store
- [ ] Version control and updates

**Success Criteria:**
- Legal documents comprehensive
- Compliant with App Store requirements
- User rights clearly explained
- Easily accessible in app

**Assignee:** Legal Counsel
**Estimate:** 3 days

### Issue #50: Phase 5.5 - TestFlight Setup & Beta Testing
**Labels:** `priority:high`, `phase:polish`, `area:infrastructure`

**Description:**
Set up TestFlight distribution and recruit beta testers.

**TestFlight Configuration:**
- [ ] Create App Store Connect record
- [ ] Configure TestFlight settings
- [ ] Set up internal testing group
- [ ] Create external testing group

**Beta Testing Program:**
- [ ] Recruit 50-100 beta testers
- [ ] Target college students and gym-goers
- [ ] Create testing instructions
- [ ] Set up feedback collection

**Testing Infrastructure:**
- [ ] Bug reporting system
- [ ] User feedback forms
- [ ] Performance monitoring
- [ ] Crash reporting setup

**Success Criteria:**
- TestFlight builds distributing
- Beta testers actively using app
- Feedback collection working
- Major bugs identified and fixed

**Assignee:** QA Lead
**Estimate:** 4 days

---

## Phase 6: Launch Issues

### Issue #51: Phase 6.1 - App Store Submission & Approval
**Labels:** `priority:high`, `phase:launch`, `area:infrastructure`

**Description:**
Submit app to App Store and manage approval process.

**Pre-Submission Checklist:**
- [ ] All App Store assets ready
- [ ] Privacy policy and terms published
- [ ] TestFlight beta testing completed
- [ ] Critical bugs fixed
- [ ] Performance optimized

**Submission Process:**
- [ ] Fill out App Store Connect information
- [ ] Upload screenshots and preview video
- [ ] Write comprehensive review notes
- [ ] Submit for review

**Approval Management:**
- [ ] Monitor review status daily
- [ ] Respond to reviewer questions within 24 hours
- [ ] Prepare for rejections and resubmissions
- [ ] Plan B if Family Controls rejected

**Success Criteria:**
- App submitted successfully
- Approval obtained within 2-3 weeks
- All reviewer feedback addressed
- Launch date confirmed

**Assignee:** Product Manager
**Estimate:** 1 week

### Issue #52: Phase 6.2 - Campus Blitz Execution
**Labels:** `priority:high`, `phase:launch`, `area:marketing`

**Description:**
Execute guerrilla marketing campaign on target college campuses.

**Preparation:**
- [ ] Print 500 flyers per campus
- [ ] Design QR codes linking to App Store
- [ ] Recruit 2-3 ambassadors per campus
- [ ] Schedule distribution times

**Distribution Strategy:**
- [ ] Campus gyms (peak hours)
- [ ] Library study areas
- [ ] Greek life areas
- [ ] Athletic facilities
- [ ] Student unions

**Ambassador Program:**
- [ ] Free lifetime Pro accounts
- [ ] Commission on referrals
- [ ] Training and materials
- [ ] Performance tracking

**Success Criteria:**
- Flyers distributed on 3-5 campuses
- QR code scans tracked
- Ambassador program launched
- Initial user acquisition from campuses

**Assignee:** Marketing Lead
**Estimate:** 1 week

### Issue #53: Phase 6.3 - Influencer Seeding Campaign
**Labels:** `priority:high`, `phase:launch`, `area:marketing`

**Description:**
Launch influencer partnerships for initial user acquisition.

**Outreach Execution:**
- [ ] Send 50 personalized outreach emails
- [ ] Follow up after 3 days
- [ ] Negotiate partnership terms
- [ ] Provide promo codes for tracking

**Content Creation:**
- [ ] Create content guidelines for influencers
- [ ] Provide high-quality screenshots
- [ ] Set up affiliate tracking
- [ ] Monitor content performance

**Partnership Management:**
- [ ] Track referral conversions
- [ ] Pay out commissions
- [ ] Maintain relationships
- [ ] Scale successful partnerships

**Success Criteria:**
- 10-20 influencers activated
- Content published and performing
- Referral tracking working
- Positive ROI on influencer spend

**Assignee:** Marketing Lead
**Estimate:** 2 weeks

### Issue #54: Phase 6.4 - Social Media Launch Content
**Labels:** `priority:high`, `phase:launch`, `area:marketing`

**Description:**
Execute comprehensive social media launch campaign.

**Content Calendar:**
- [ ] Pre-launch teaser posts
- [ ] Launch day announcement
- [ ] Feature highlight posts
- [ ] User-generated content reposts
- [ ] Behind-the-scenes content

**Platform Strategy:**
- [ ] Instagram: Visual posts and Stories
- [ ] TikTok: Demo videos and skits
- [ ] Twitter: Thread explainers and engagement
- [ ] Reddit: r/productivity and campus subreddits

**Engagement Tactics:**
- [ ] Polls and questions
- [ ] Giveaways and contests
- [ ] AMA sessions
- [ ] Community building

**Success Criteria:**
- All platforms active and posting
- Engagement rates above industry average
- User-generated content flowing
- Community growing organically

**Assignee:** Social Media Manager
**Estimate:** 2 weeks

---

## Phase 7: Growth & Iteration Issues

### Issue #55: Phase 7.1 - Campus Expansion to 10 Schools
**Labels:** `priority:medium`, `phase:growth`, `area:marketing`

**Description:**
Expand campus presence to 10 major universities.

**Target Selection:**
- [ ] Research top 10 state schools
- [ ] Prioritize gym culture and Greek life
- [ ] Consider geographic diversity
- [ ] Analyze social media activity

**Expansion Tactics:**
- [ ] Ambassador recruitment per campus
- [ ] Localized flyer campaigns
- [ ] Campus partnership outreach
- [ ] Social media targeting

**Measurement:**
- [ ] Downloads per campus
- [ ] User retention rates
- [ ] Viral coefficient by campus
- [ ] Cost per acquisition

**Success Criteria:**
- 10 campuses with active presence
- Consistent user acquisition
- Positive word-of-mouth growth
- Scalable expansion model

**Assignee:** Growth Manager
**Estimate:** 4 weeks

### Issue #56: Phase 7.2 - Viral Mechanics Optimization
**Labels:** `priority:medium`, `phase:growth`, `area:product`

**Description:**
Optimize product features for viral growth and sharing.

**Shareable Moments:**
- [ ] Jail screenshots with branded templates
- [ ] Streak milestone graphics
- [ ] Fine announcement cards
- [ ] Pack stats visualizations

**Social Integration:**
- [ ] Instagram Stories export
- [ ] TikTok sharing templates
- [ ] Twitter card optimization
- [ ] Snapchat integration

**Referral Program:**
- [ ] Enhanced referral UI
- [ ] Viral loop incentives
- [ ] Social proof displays
- [ ] Gamified sharing

**Success Criteria:**
- Viral coefficient >1.2
- 50% of new users from referrals
- High engagement on shared content
- Organic growth accelerating

**Assignee:** Product Manager
**Estimate:** 6 weeks

---

## Technical Architecture Issues

### Issue #57: Database Schema Implementation
**Labels:** `priority:high`, `phase:foundation`, `area:backend`

**Description:**
Implement complete PostgreSQL database schema for Pakkt.

**Core Tables:**
- [ ] users (profiles, stats, subscription)
- [ ] packs (groups, settings, stats)
- [ ] pack_members (membership, roles)
- [ ] goals (objectives, settings)
- [ ] check_ins (completions, photos)
- [ ] fines (violations, voting)
- [ ] phone_jails (restrictions, status)

**Supporting Tables:**
- [ ] fine_votes (democratic voting)
- [ ] reactions (social engagement)
- [ ] comments (discussion)
- [ ] notifications (activity feeds)

**Indexes & Performance:**
- [ ] Optimize for common queries
- [ ] Add composite indexes
- [ ] Plan for scaling to 100K+ users

**Success Criteria:**
- All tables created and populated
- Relationships correctly established
- RLS policies enforced
- Performance optimized

**Assignee:** Backend Developer
**Estimate:** 5 days

### Issue #58: Cloudflare Workers API Implementation
**Labels:** `priority:high`, `phase:foundation`, `area:backend`

**Description:**
Build complete REST API using Cloudflare Workers and Hono.

**Core Endpoints:**
- [ ] Authentication (/auth/*)
- [ ] User management (/users/*)
- [ ] Pack operations (/packs/*)
- [ ] Goal management (/goals/*)
- [ ] Check-in handling (/checkins/*)
- [ ] Fine system (/fines/*)
- [ ] Jail management (/jail/*)

**Middleware:**
- [ ] JWT authentication
- [ ] Rate limiting
- [ ] Request validation
- [ ] Error handling
- [ ] CORS configuration

**Real-time Features:**
- [ ] WebSocket connections
- [ ] Live updates for feeds
- [ ] Real-time voting
- [ ] Instant notifications

**Success Criteria:**
- All API endpoints functional
- Authentication working
- Real-time features operational
- Performance <200ms response time

**Assignee:** Backend Developer
**Estimate:** 10 days

---

## iOS App Development Issues

### Issue #59: Core Architecture Setup (MVVM + Repository)
**Labels:** `priority:high`, `phase:foundation`, `area:ios`

**Description:**
Establish solid iOS app architecture following MVVM pattern.

**Project Structure:**
- [ ] App/ (main app logic)
- [ ] Features/ (feature modules)
- [ ] Core/ (shared utilities)
- [ ] DesignSystem/ (UI components)
- [ ] Resources/ (assets, strings)

**MVVM Implementation:**
- [ ] ViewModels for business logic
- [ ] Repository pattern for data
- [ ] ObservableObject for reactive UI
- [ ] Combine for async operations

**Networking Layer:**
- [ ] APIClient with async/await
- [ ] Request/response models
- [ ] Error handling
- [ ] Token refresh logic

**Success Criteria:**
- Clean architecture established
- Code organization logical
- Separation of concerns maintained
- Easy to test and maintain

**Assignee:** iOS Developer
**Estimate:** 5 days

### Issue #60: Design System Implementation
**Labels:** `priority:high`, `phase:foundation`, `area:ios`

**Description:**
Implement complete design system in SwiftUI.

**Color System:**
- [ ] PakktColors struct with all colors
- [ ] Dark theme color scheme
- [ ] Semantic color usage
- [ ] Dynamic color support

**Typography:**
- [ ] Font extensions for SF Pro
- [ ] Text style constants
- [ ] Dynamic type support
- [ ] ALL CAPS text component

**Component Library:**
- [ ] GlassCard, GlassButton components
- [ ] Avatar, Badge, StatusIndicator
- [ ] Form fields and inputs
- [ ] Loading and error states

**Success Criteria:**
- All design tokens implemented
- Components reusable and consistent
- Dark neobrutalism aesthetic achieved
- Performance optimized

**Assignee:** iOS Developer
**Estimate:** 7 days

---

## Design System Issues

### Issue #61: Complete Figma Design System
**Labels:** `priority:high`, `phase:foundation`, `area:design`

**Description:**
Create comprehensive Figma design system with all components and screens.

**Foundation:**
- [ ] Color palette and gradients
- [ ] Typography scale (H1-H3, body styles)
- [ ] Spacing system (8pt grid)
- [ ] Border radius and shadows

**Components:**
- [ ] Buttons (Primary, Danger, Secondary)
- [ ] Cards (Glass, Pack, Check-in, Fine, Jail)
- [ ] Inputs (Text field, Phone, Slider)
- [ ] Navigation (Tab bar, Nav bar)
- [ ] Status (Badges, Indicators, Loading)

**Screens:**
- [ ] Authentication flow
- [ ] Onboarding (5 screens)
- [ ] Main app (Feed, Packs, Goals, Profile)
- [ ] Feature screens (Check-in, Fine voting, Jail)

**Interactive Prototype:**
- [ ] Figma prototype with all flows
- [ ] User testing sessions
- [ ] Iterate based on feedback

**Success Criteria:**
- Complete component library
- All screens designed
- Interactive prototype functional
- Design system documented

**Assignee:** UI/UX Designer
**Estimate:** 10 days

---

## Go-To-Market Issues

### Issue #62: Landing Page Development
**Labels:** `priority:high`, `phase:foundation`, `area:marketing`

**Description:**
Build and launch pakkt.app landing page.

**Page Structure:**
- [ ] Hero section with tagline
- [ ] How it works (3 steps)
- [ ] Feature highlights (phone jail, fines)
- [ ] Pricing section
- [ ] Email capture for waitlist

**Technical Implementation:**
- [ ] Responsive design (mobile-first)
- [ ] Fast loading (<2 seconds)
- [ ] SEO optimized
- [ ] Analytics integrated

**Content:**
- [ ] Compelling copy
- [ ] High-quality screenshots
- [ ] Video demo (optional)
- [ ] Social proof (testimonials)

**Success Criteria:**
- Landing page live and functional
- Mobile optimized
- Conversion tracking working
- Professional appearance

**Assignee:** Web Developer
**Estimate:** 5 days

### Issue #63: Social Media Setup
**Labels:** `priority:high`, `phase:foundation`, `area:marketing`

**Description:**
Set up and optimize all social media accounts.

**Account Creation:**
- [ ] Instagram @pakkt.app
- [ ] TikTok @pakkt.app
- [ ] Twitter @pakkt_app
- [ ] LinkedIn (optional)

**Profile Optimization:**
- [ ] Consistent branding
- [ ] Compelling bios
- [ ] Profile/cover images
- [ ] Link to landing page

**Content Strategy:**
- [ ] Pre-launch teaser content
- [ ] Posting schedule
- [ ] Engagement tactics
- [ ] Hashtag strategy (#ShowUpOrPayUp)

**Success Criteria:**
- All accounts created and optimized
- Content calendar planned
- Engagement strategy defined
- Community building started

**Assignee:** Social Media Manager
**Estimate:** 3 days

---

## Testing & QA Issues

### Issue #64: Unit Testing Infrastructure
**Labels:** `priority:medium`, `phase:foundation`, `area:testing`

**Description:**
Set up comprehensive unit testing for iOS and backend.

**iOS Testing:**
- [ ] XCTest framework configured
- [ ] Unit tests for ViewModels
- [ ] Unit tests for Repositories
- [ ] Mock data and networking
- [ ] CI integration

**Backend Testing:**
- [ ] Test framework for Workers
- [ ] API endpoint tests
- [ ] Database operation tests
- [ ] Mock external services

**Coverage Goals:**
- [ ] 70%+ code coverage
- [ ] Critical paths fully tested
- [ ] Regression prevention
- [ ] Automated test execution

**Success Criteria:**
- Testing infrastructure operational
- Core logic fully tested
- CI running tests automatically
- Coverage reports generated

**Assignee:** QA Engineer
**Estimate:** 5 days

### Issue #65: End-to-End Testing
**Labels:** `priority:medium`, `phase:polish`, `area:testing`

**Description:**
Implement end-to-end testing for critical user flows.

**Test Scenarios:**
- [ ] Complete user registration
- [ ] Pack creation and joining
- [ ] Goal creation and check-in
- [ ] Fine voting and payment
- [ ] Phone jail activation

**Testing Tools:**
- [ ] XCUITest for iOS
- [ ] Playwright for web (optional)
- [ ] API testing tools
- [ ] Device farm testing

**Automation:**
- [ ] CI/CD integration
- [ ] Screenshot comparison
- [ ] Performance monitoring
- [ ] Cross-device testing

**Success Criteria:**
- All critical flows tested
- E2E tests running in CI
- Regression detection working
- Test maintenance manageable

**Assignee:** QA Engineer
**Estimate:** 7 days

---

## Summary

This document outlines **65 detailed GitHub issues** covering all phases of Pakkt development:

- **Phase 0 (Foundation)**: 6 issues - Planning, environment setup, infrastructure
- **Phase 1 (MVP)**: 19 issues - Authentication, packs, goals, check-ins
- **Phase 2 (Consequences)**: 10 issues - Fine system, phone jail
- **Phase 3 (Social)**: 9 issues - Feed, reactions, gamification
- **Phase 4 (Payments)**: 7 issues - Subscriptions, real money fines
- **Phase 5 (Polish)**: 5 issues - App Store prep, beta testing
- **Phase 6 (Launch)**: 4 issues - Launch execution
- **Phase 7 (Growth)**: 2 issues - Expansion and optimization
- **Technical Architecture**: 2 issues - Database and API
- **iOS Development**: 2 issues - Architecture and design system
- **Design System**: 1 issue - Complete Figma system
- **Go-To-Market**: 2 issues - Landing page and social media
- **Testing & QA**: 2 issues - Unit and E2E testing

Each issue includes:
- Clear description and scope
- Detailed task checklists
- Success criteria
- Appropriate labels and priority
- Assignee suggestions
- Time estimates

This provides a comprehensive roadmap for the entire Pakkt development lifecycle.