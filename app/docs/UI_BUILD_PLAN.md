# Pakkt UI Build Plan - Visual Only (No Functionality)

## 🎨 UI Pages to Build

### 🔐 Auth Flow (1 page)
- [ ] **LoginView** - Just Apple Sign In button + Pakkt logo

### 🚀 Onboarding Flow (2 pages)
- [ ] **OnboardingView** - Welcome screens
- [ ] **OnboardingStepView** - Individual steps

### 📱 Main App - 3 Tabs

#### Tab 1: FEED 🏠 (3 pages)
- [x] **FeedView** - Main feed showing check-ins ✅ DONE!
- [ ] **PostDetailView** - Individual check-in details
- [ ] **CommentsView** - Comments section

#### Tab 2: PACKS 📦 (4 pages)
- [ ] **PackListView** - List all packs
- [ ] **PackDetailView** - Pack details, members, stats
- [ ] **CreatePackView** - Create new pack form
- [ ] **EditPackView** - Edit pack settings

#### Tab 3: PROFILE 👤 (4 pages)
- [ ] **ProfileView** - User profile page
- [ ] **EditProfileView** - Edit profile form
- [ ] **SettingsView** - App settings
- [ ] **AboutView** - About/help page

### 🎯 Detail/Modal Pages (4 pages)
- [ ] **CheckInDetailView** - Check-in with proof photo
- [ ] **FineDetailView** - Fine with voting interface
- [ ] **GoalDetailView** - Goal progress tracker
- [ ] **CreateCheckInView** - Camera + upload interface

---

## 🚨 MVP ARCHITECTURE (1 PACK ONLY!)
**You are in ONE default pack. Feed = your pack's check-ins.**

### Main App Tabs:
1. **Feed** 🏠 - Your pack's check-ins (NOT all packs!)
2. **Profile** 👤 - Your profile + settings

NO PACK LIST! NO MULTIPLE PACKS!

## 🔥 PRIORITY ORDER (Build These First!)
1. ✅ **FeedView** - DONE! (Shows your pack's check-ins)
2. **CreateCheckInView** - Camera + check-in for YOUR pack
3. **FineDetailView** - Fine with voting (in your pack)
4. **GoalDetailView** - Goal progress (your goals in pack)
5. **ProfileView** - User profile
6. **PackSettingsView** - Manage YOUR pack (settings, members)

## 📦 DO LATER (Post-MVP)
- LoginView (Apple Sign In)
- Onboarding
- Multiple packs feature
- Settings/About
- etc...

## Current Status
- ✅ NotificationSettingsView - Already exists
- 🔄 Building visual-only UI (no backend integration)

## Notes
- Focus on SwiftUI layout and design
- Use placeholder data
- No API calls yet
- No real navigation logic yet
