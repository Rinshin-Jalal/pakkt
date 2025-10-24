# Pakkt iOS + Backend Comprehensive Audit Results

**Date:** 2025-10-24
**Scope:** Push Notifications, Realtime, Uploads, Camera Integration
**Status:** 90% Complete - Critical Gaps Identified

---

## 🔍 Executive Summary

The service layer is **90% functional** with all core iOS services implemented. However, there are **2 critical blockers** preventing production readiness:

1. **🚨 APNs Backend Delivery Not Implemented** - Push tokens are registered but never sent
2. **🚨 Supabase Realtime Requires Manual Configuration** - Tables need replica identity setup

Additionally, there is **zero test coverage** for notifications, uploads, and camera services.

---

## ✅ FULLY IMPLEMENTED FEATURES

### 1. Push Device Registration ✅

#### Backend API
- ✅ `POST /api/users/push-token` - Register device token
- ✅ `DELETE /api/users/push-token` - Remove token
- ✅ Database table: `push_tokens` with device tracking
- ✅ Validation: `pushTokenSchema` in validators.ts
- ✅ Service: `registerPushToken()`, `deletePushToken()` in users/services.ts

**Files:**
- `backend/src/features/users/router.ts:21-22`
- `backend/src/features/users/routes.ts:35-68`
- `backend/src/features/users/services.ts` (push token functions)

#### iOS Implementation
- ✅ `NotificationService.registerDeviceToken()` - Converts Data to hex string
- ✅ `UsersService.registerPushToken()` - API integration
- ✅ Device ID tracking: `UIDevice.current.identifierForVendor`
- ✅ Token formatting: Hex conversion implemented correctly

**Files:**
- `app/Pakkt/Core/Services/NotificationService.swift:28-36`
- `app/Pakkt/Features/Users/Services/UsersService.swift:77-82`

**Status:** ✅ **PRODUCTION READY**

---

### 2. Supabase Realtime Service ✅/⚠️

#### iOS Implementation ✅
Complete realtime subscription service with 4 subscription types:

- ✅ `subscribeToCheckIns(packId, onInsert)` - Live check-in updates
- ✅ `subscribeToFineVotes(fineId, onInsert)` - Live voting updates
- ✅ `subscribeToComments(checkInId, onInsert)` - Live comment updates
- ✅ `subscribeToReactions(checkInId, onInsert)` - Live reaction updates
- ✅ `unsubscribe(channelId)` + `unsubscribeAll()` - Cleanup methods

**Files:**
- `app/Pakkt/Core/Services/SupabaseRealtimeService.swift`

**Implementation Details:**
- Uses Supabase Swift SDK RealtimeV2
- Proper channel management with unique IDs
- InsertAction change detection
- JSON encoding/decoding for type safety

#### Backend Configuration ⚠️
**STATUS:** ⚠️ **MANUAL SETUP REQUIRED**

**Missing:**
- No SQL migration files found for replica identity
- Tables need manual configuration via Supabase Dashboard

**Required Manual Steps:**
```sql
-- Enable realtime on tables (via Supabase SQL Editor)
ALTER TABLE check_ins REPLICA IDENTITY FULL;
ALTER TABLE fine_votes REPLICA IDENTITY FULL;
ALTER TABLE comments REPLICA IDENTITY FULL;
ALTER TABLE reactions REPLICA IDENTITY FULL;
```

**Then in Supabase Dashboard:**
1. Navigate to: Database → Replication
2. Add tables to realtime publication:
   - `check_ins`
   - `fine_votes`
   - `comments`
   - `reactions`

**Status:** ⚠️ **MANUAL CONFIGURATION NEEDED**

---

### 3. Cloudflare R2 Upload API ✅

#### Backend Implementation ✅
Complete file upload system with R2 integration:

- ✅ `POST /api/uploads/presigned-url` - Generate upload endpoint
- ✅ `PUT /api/uploads/direct/:key` - Direct Worker upload
- ✅ `DELETE /api/uploads/:key` - Delete file
- ✅ `GET /api/uploads/history` - User upload history
- ✅ `GET /api/uploads/stats` - User upload statistics

**Files:**
- `backend/src/features/uploads/router.ts`
- `backend/src/features/uploads/routes.ts`
- `backend/src/features/uploads/services.ts`
- `backend/src/lib/r2.ts` - R2 bucket operations

**Features:**
- Pack membership validation for pack-scoped uploads
- Upload metadata tracking in database
- File key generation with user/pack/purpose segmentation
- Public URL generation from R2 public bucket
- Max file size enforcement per file type

#### iOS Implementation ✅
Complete upload service with image optimization:

- ✅ `UploadsService.uploadImage(image, filename?)` - Full upload flow
- ✅ JPEG compression (80% quality default)
- ✅ Presigned URL request/response handling
- ✅ R2 PUT upload via URLSession
- ✅ Public URL returned for database storage

**Files:**
- `app/Pakkt/Features/Uploads/Services/UploadsService.swift`
- `app/Pakkt/Features/Uploads/Models/UploadModels.swift`

**Flow:**
1. Compress image to JPEG (80% quality)
2. Generate unique filename
3. Request presigned URL from backend
4. Upload to R2 via PUT request
5. Return public URL for API submission

**Status:** ✅ **PRODUCTION READY**

---

### 4. Real-time Check-in Experience ✅

Complete end-to-end check-in flow from camera to API:

#### Camera Service ✅
- ✅ `CameraService.requestCameraAccess()` - AVFoundation authorization
- ✅ `CameraService.checkCameraAuthorization()` - Status checking
- ✅ `CameraService.compressImage(maxSizeKB)` - Progressive compression
- ✅ `CameraService.resizeImage(maxDimension)` - Max 1024px dimension

**Files:**
- `app/Pakkt/Features/CheckIns/Services/CameraService.swift`

**Features:**
- Progressive JPEG compression (starts at 80%, reduces to 10%)
- Intelligent resizing (maintains aspect ratio)
- Authorization state handling (authorized, denied, restricted, notDetermined)

#### Check-in Submission ✅
- ✅ `CheckInsService.submitCheckIn(goalId, proofImage, caption)`
- ✅ Optional proof image upload
- ✅ Caption support
- ✅ Complete integration: Camera → Upload → API

**Files:**
- `app/Pakkt/Features/CheckIns/Services/CheckInsService.swift:18-39`

**Flow:**
```swift
1. User captures photo with camera
2. CameraService compresses/resizes image
3. UploadsService uploads to R2
4. CheckInsService submits check-in with proof URL
5. Backend creates check-in record with streak/XP calculation
```

#### Info.plist Permissions ✅
- ✅ `NSCameraUsageDescription` - "Pakkt needs camera access to capture proof of check-ins"
- ✅ `NSPhotoLibraryUsageDescription` - "Pakkt needs photo library access to select proof images"
- ✅ `UIBackgroundModes` - `remote-notification` array

**Files:**
- `app/Pakkt/Info.plist`

**Status:** ✅ **PRODUCTION READY**

---

### 5. NotificationService Implementation ✅

Complete local and push notification management:

#### Authorization ✅
- ✅ `requestAuthorization()` - Request .alert, .sound, .badge permissions
- ✅ `checkAuthorizationStatus()` - Check UNAuthorizationStatus
- ✅ Async/await based permission flow

#### Device Token Management ✅
- ✅ `registerDeviceToken(Data)` - Convert to hex, send to backend
- ✅ Integration with `UsersService.registerPushToken()`
- ✅ Device type: "ios"
- ✅ Device ID: `UIDevice.current.identifierForVendor`

#### Local Notifications ✅
- ✅ `scheduleCheckInReminder(goal)` - Calendar-based recurring reminders
- ✅ `cancelCheckInReminder(goalId)` - Remove specific reminder
- ✅ `cancelAllNotifications()` - Clear all pending notifications

**Files:**
- `app/Pakkt/Core/Services/NotificationService.swift`

**Features:**
- UNCalendarNotificationTrigger for time-based goals
- Custom category: "CHECK_IN_REMINDER"
- Goal ID in userInfo for deep linking
- Repeating notifications for recurring goals

**Status:** ✅ **PRODUCTION READY** (client-side only)

---

## ❌ CRITICAL GAPS

### 1. Backend APNs Notification Delivery 🚨

**STATUS:** ❌ **NOT IMPLEMENTED**

**Current State:**
- Push tokens are successfully registered and stored in database ✅
- NotificationService on iOS is complete and functional ✅
- **MISSING:** Backend has NO code to actually send push notifications ❌

**What's Missing:**

#### A. APNs HTTP/2 Client
No implementation of Apple Push Notification service client:

**Required File:** `backend/src/lib/apns.ts`
```typescript
import apn from 'apn'

interface PushNotification {
  token: string
  title: string
  body: string
  badge?: number
  sound?: string
  data?: Record<string, any>
}

export async function sendPushNotification(
  notification: PushNotification
): Promise<void> {
  // 1. Initialize APNs HTTP/2 connection
  // 2. Format notification payload
  // 3. Send to Apple servers
  // 4. Handle delivery receipt/errors
}

export async function sendBatchNotifications(
  notifications: PushNotification[]
): Promise<void> {
  // Batch sending for efficiency
}
```

#### B. Notification Queue System
No background job system for sending notifications:

**Required File:** `backend/src/features/notifications/queue.ts`
```typescript
// Queue notifications for delivery
export async function queueNotification(
  userId: string,
  type: NotificationType,
  data: Record<string, any>
): Promise<void> {
  // 1. Look up user's push tokens
  // 2. Format notification based on type
  // 3. Queue for delivery (Cloudflare Queues or Durable Objects)
}
```

#### C. Notification Templates
No message formatting logic:

**Required File:** `backend/src/features/notifications/templates.ts`
```typescript
export const notificationTemplates = {
  NEW_CHECK_IN: (username: string, goalTitle: string) => ({
    title: `${username} checked in!`,
    body: `${goalTitle} - Keep the streak alive!`,
    category: 'CHECK_IN',
  }),
  FINE_VOTE_NEEDED: (username: string, amount: number) => ({
    title: 'Vote on fine',
    body: `${username} missed a check-in. Fine: $${amount / 100}`,
    category: 'FINE_VOTE',
  }),
  NEW_COMMENT: (username: string) => ({
    title: `${username} commented`,
    body: 'Someone commented on your check-in',
    category: 'COMMENT',
  }),
  // ... more templates
}
```

#### D. Trigger Integration
No hooks to send notifications on events:

**Required Changes:**
- `backend/src/features/checkins/services.ts` - Send notification after check-in created
- `backend/src/features/fines/services.ts` - Send notification when fine created/voted
- `backend/src/features/social/services.ts` - Send notification on comment/reaction

**Example:**
```typescript
// In createCheckIn service
await createCheckInRecord(...)

// MISSING: Notify pack members
const packMembers = await getPackMembers(packId)
for (const member of packMembers) {
  await queueNotification(member.userId, 'NEW_CHECK_IN', {
    checkInId,
    username,
    goalTitle,
  })
}
```

#### E. Environment Variables
**Required .env entries:**
```bash
APNS_KEY_ID=ABC123XYZ
APNS_TEAM_ID=DEF456UVW
APNS_KEY=-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----
APNS_PRODUCTION=false  # false for sandbox, true for production
```

**How to Get:**
1. Apple Developer Account → Certificates, Identifiers & Profiles
2. Keys → Create new key with APNs capability
3. Download .p8 key file (only available once!)
4. Copy key ID and team ID from Apple Developer

#### F. Dependencies
**Required packages:**
```json
{
  "dependencies": {
    "apn": "^2.2.0",  // or "node-apn"
    "@types/apn": "^2.1.3"
  }
}
```

**Implementation Priority:** 🚨 **CRITICAL - BLOCKING PRODUCTION**

**Estimated Effort:** 4-6 hours
- 2 hours: APNs client setup + testing
- 2 hours: Notification templates + queue system
- 1 hour: Trigger integration in existing services
- 1 hour: Testing end-to-end flow

---

### 2. Supabase Realtime Table Configuration 🚨

**STATUS:** ❌ **NOT CONFIGURED**

**Problem:**
- iOS `SupabaseRealtimeService` is complete and ready ✅
- Backend RLS policies exist ✅
- **MISSING:** Tables not configured for realtime replication ❌

**Manual Configuration Required:**

#### Step 1: Enable Replica Identity
Open Supabase SQL Editor and run:

```sql
-- Enable full row tracking for realtime
ALTER TABLE check_ins REPLICA IDENTITY FULL;
ALTER TABLE fine_votes REPLICA IDENTITY FULL;
ALTER TABLE comments REPLICA IDENTITY FULL;
ALTER TABLE reactions REPLICA IDENTITY FULL;
```

**Why FULL?**
- Allows realtime to broadcast all column values on changes
- Required for iOS to receive complete record data
- Without this, only PRIMARY KEY columns are broadcast

#### Step 2: Add to Realtime Publication
Via Supabase Dashboard:

1. **Navigate:** Database → Replication
2. **Find:** "supabase_realtime" publication
3. **Add tables:**
   - ☐ `check_ins`
   - ☐ `fine_votes`
   - ☐ `comments`
   - ☐ `reactions`
4. **Save changes**

**Verification:**
```sql
-- Check replica identity
SELECT schemaname, tablename, repident
FROM pg_tables
JOIN pg_class ON pg_tables.tablename = pg_class.relname
JOIN pg_namespace ON pg_class.relnamespace = pg_namespace.oid
WHERE schemaname = 'public'
AND tablename IN ('check_ins', 'fine_votes', 'comments', 'reactions');

-- Expected output: repident = 'f' (full)

-- Check publication
SELECT * FROM pg_publication_tables
WHERE pubname = 'supabase_realtime'
AND tablename IN ('check_ins', 'fine_votes', 'comments', 'reactions');

-- Expected: 4 rows returned
```

**RLS Policies:**
Ensure policies allow realtime subscription:
- Users can only subscribe to packs they're members of
- Realtime respects RLS automatically (SELECT policies apply)

**Testing:**
After configuration, test with iOS app:
```swift
// Should receive live updates
await realtimeService.subscribeToCheckIns(packId: packId) { checkIn in
    print("New check-in: \(checkIn.id)")
}
```

**Implementation Priority:** 🚨 **CRITICAL - REQUIRED FOR LIVE FEATURES**

**Estimated Effort:** 15 minutes (manual setup)

---

## ⚠️ HIGH PRIORITY GAPS

### 3. Unit Tests Coverage 🚨

**STATUS:** ❌ **ZERO TEST COVERAGE**

**Missing Test Files:**
```
app/PakktTests/Core/Services/
├── NotificationServiceTests.swift ❌
├── SupabaseRealtimeServiceTests.swift ❌

app/PakktTests/Features/Uploads/Services/
├── UploadsServiceTests.swift ❌

app/PakktTests/Features/CheckIns/Services/
├── CameraServiceTests.swift ❌
├── CheckInsServiceTests.swift ❌
```

**Required Test Coverage:**

#### A. NotificationServiceTests
```swift
func testRequestAuthorization_Granted()
func testRequestAuthorization_Denied()
func testRegisterDeviceToken_ValidToken()
func testScheduleCheckInReminder_ValidGoal()
func testCancelCheckInReminder()
```

#### B. UploadsServiceTests
```swift
func testUploadImage_SuccessfulUpload()
func testUploadImage_CompressionFailure()
func testUploadImage_NetworkError()
func testUploadToR2_InvalidURL()
```

#### C. CameraServiceTests
```swift
func testRequestCameraAccess_FirstTime()
func testRequestCameraAccess_Denied()
func testCompressImage_WithinLimit()
func testCompressImage_ExceedsLimit()
func testResizeImage_LandscapeOrientation()
```

**Mocking Requirements:**
- `MockUsersService` for push token registration
- `MockAPIClient` for upload API calls
- `MockUNUserNotificationCenter` for notification testing
- `MockAVCaptureDevice` for camera authorization

**Implementation Priority:** ⚠️ **HIGH - REQUIRED FOR PRODUCTION**

**Estimated Effort:** 6-8 hours
- 2 hours: Mock implementations
- 3 hours: NotificationService + SupabaseRealtime tests
- 2 hours: Uploads + Camera tests
- 1 hour: Integration test scenarios

---

### 4. Onboarding Permission Flow ⚠️

**STATUS:** ⚠️ **SERVICE READY, NO UI**

**Current State:**
- `NotificationService.requestAuthorization()` exists and works ✅
- No onboarding flow to educate users before requesting ❌
- No handling of "denied" state in UI ❌

**Required Implementation:**

#### A. Educational Screen
Pre-permission screen explaining value:

```swift
struct NotificationOnboardingView: View {
    @State private var showPermissionSheet = false

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 80))

            Text("Stay Connected with Your Pack")
                .font(.title.bold())

            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(
                    icon: "checkmark.circle",
                    title: "Check-in Reminders",
                    description: "Never miss your daily goals"
                )
                FeatureRow(
                    icon: "person.2",
                    title: "Pack Activity",
                    description: "See when teammates check in"
                )
                FeatureRow(
                    icon: "gavel",
                    title: "Vote Notifications",
                    description: "Participate in fine decisions"
                )
            }

            Button("Enable Notifications") {
                Task {
                    await requestPermission()
                }
            }
            .buttonStyle(.borderedProminent)

            Button("Maybe Later") {
                skipOnboarding()
            }
        }
    }
}
```

#### B. Settings Deep Link
Handle "denied" state with Settings link:

```swift
struct NotificationDeniedView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("Notifications Disabled")
                .font(.headline)

            Text("Enable notifications in Settings to get important pack updates")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
```

#### C. Permission State Management
Track permission flow in app state:

```swift
enum NotificationPermissionState {
    case notRequested
    case requesting
    case authorized
    case denied
    case provisional  // iOS 15+ quiet notifications
}

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var permissionState: NotificationPermissionState = .notRequested

    private let notificationService: NotificationService

    func requestNotificationPermission() async {
        permissionState = .requesting

        do {
            let granted = try await notificationService.requestAuthorization()
            permissionState = granted ? .authorized : .denied

            // Register device token if granted
            if granted {
                // Device token registration happens in AppDelegate
            }
        } catch {
            permissionState = .denied
        }
    }
}
```

#### D. Onboarding Flow Integration
Add to main onboarding sequence:

```swift
struct OnboardingFlow: View {
    @State private var currentStep = 0

    var body: some View {
        TabView(selection: $currentStep) {
            WelcomeView().tag(0)
            PackExplainerView().tag(1)
            GoalsExplainerView().tag(2)
            NotificationOnboardingView().tag(3)  // <-- Add here
            CompleteOnboardingView().tag(4)
        }
        .tabViewStyle(.page)
    }
}
```

**Implementation Priority:** ⚠️ **HIGH - BETTER UX**

**Estimated Effort:** 3-4 hours

---

## 💡 NICE TO HAVE

### 5. Image Optimization & Caching

**STATUS:** ⚠️ **PARTIAL**

**Current Implementation:**
- ✅ Client-side JPEG compression (80% quality)
- ✅ Client-side resizing (1024px max dimension)
- ✅ R2 public bucket serving images

**Missing Optimizations:**

#### A. Cloudflare Images Integration
Transform images on-the-fly:

```typescript
// backend/src/lib/images.ts
export function getOptimizedImageURL(
  publicUrl: string,
  variant: 'thumbnail' | 'medium' | 'large'
): string {
  const variants = {
    thumbnail: 'width=150,height=150,fit=cover',
    medium: 'width=600,height=600,fit=contain',
    large: 'width=1200,height=1200,fit=contain',
  }

  // Cloudflare Images URL format
  return `https://imagedelivery.net/${CF_ACCOUNT_HASH}/${publicUrl}/${variants[variant]}`
}
```

#### B. WebP Conversion
Serve modern format with fallback:

```swift
// iOS: Accept WebP
extension URLRequest {
    mutating func addImageAcceptHeader() {
        setValue("image/webp,image/jpeg", forHTTPHeaderField: "Accept")
    }
}

// Backend: Convert to WebP on upload
import sharp from 'sharp'

async function optimizeImage(buffer: ArrayBuffer): Promise<Buffer> {
  return sharp(buffer)
    .webp({ quality: 85 })
    .toBuffer()
}
```

#### C. CDN Caching Headers
Set aggressive caching on R2 responses:

```typescript
// In R2 upload service
await bucket.put(key, imageData, {
  httpMetadata: {
    contentType: 'image/jpeg',
    cacheControl: 'public, max-age=31536000, immutable',  // 1 year
  },
})
```

#### D. Responsive Image Variants
Generate multiple sizes on upload:

```typescript
async function uploadWithVariants(image: Buffer) {
  const variants = {
    thumbnail: await sharp(image).resize(150, 150, { fit: 'cover' }).toBuffer(),
    medium: await sharp(image).resize(600, 600, { fit: 'inside' }).toBuffer(),
    original: image,
  }

  // Upload all variants
  for (const [size, buffer] of Object.entries(variants)) {
    await bucket.put(`${key}-${size}`, buffer)
  }
}
```

**Implementation Priority:** 💡 **NICE TO HAVE - PERFORMANCE IMPROVEMENT**

**Estimated Effort:** 4-6 hours

**Benefits:**
- 40-60% bandwidth reduction with WebP
- Faster load times for thumbnails
- Better mobile performance
- Reduced CDN costs

---

## 📊 COMPLETION MATRIX

| Feature | Backend | iOS | Tests | Config | Status |
|---------|---------|-----|-------|--------|--------|
| **Push Token Registration** | ✅ | ✅ | ❌ | ✅ | ✅ DONE |
| **APNs Delivery** | ❌ | ✅ | ❌ | ❌ | ❌ **BLOCKED** |
| **R2 Upload API** | ✅ | ✅ | ❌ | ✅ | ✅ DONE |
| **Camera Capture** | N/A | ✅ | ❌ | ✅ | ✅ DONE |
| **Image Compression** | N/A | ✅ | ❌ | N/A | ✅ DONE |
| **Check-in Flow** | ✅ | ✅ | ❌ | ✅ | ✅ DONE |
| **Realtime Service** | ⚠️ | ✅ | ❌ | ❌ | ⚠️ **MANUAL** |
| **NotificationService** | N/A | ✅ | ❌ | ✅ | ✅ DONE |
| **Info.plist Permissions** | N/A | ✅ | N/A | ✅ | ✅ DONE |
| **Onboarding Flow** | N/A | ❌ | N/A | N/A | ❌ UI NEEDED |
| **Unit Tests** | N/A | ❌ | ❌ | N/A | ❌ NONE |
| **Image Optimization** | ⚠️ | ✅ | N/A | N/A | ⚠️ BASIC |

---

## 🎯 ACTION PLAN

### Phase 1: Critical Blockers (Day 1)
**Priority:** 🚨 **MUST DO**

1. **Implement APNs Backend Delivery** (4-6 hours)
   - [ ] Create `backend/src/lib/apns.ts` - APNs HTTP/2 client
   - [ ] Add APNs credentials to environment
   - [ ] Create notification templates
   - [ ] Add notification triggers to services
   - [ ] Test end-to-end push flow

2. **Configure Supabase Realtime** (15 min)
   - [ ] Run SQL to set replica identity FULL
   - [ ] Add tables to realtime publication
   - [ ] Verify with iOS subscription test

**Outcome:** Push notifications functional, live updates working

---

### Phase 2: Quality & UX (Day 2-3)
**Priority:** ⚠️ **SHOULD DO**

3. **Add Unit Tests** (6-8 hours)
   - [ ] Create mock implementations
   - [ ] Write NotificationService tests
   - [ ] Write UploadsService tests
   - [ ] Write CameraService tests
   - [ ] Integration test scenarios

4. **Onboarding Permission Flow** (3-4 hours)
   - [ ] Create NotificationOnboardingView
   - [ ] Add permission state management
   - [ ] Handle denied state with Settings link
   - [ ] Integrate into main onboarding flow

**Outcome:** Production-ready code quality, better user experience

---

### Phase 3: Optimization (Future)
**Priority:** 💡 **NICE TO HAVE**

5. **Image Optimization** (4-6 hours)
   - [ ] Add Cloudflare Images integration
   - [ ] Implement WebP conversion
   - [ ] Generate responsive variants
   - [ ] Add aggressive CDN caching

**Outcome:** Better performance, reduced bandwidth costs

---

## 📝 TESTING CHECKLIST

### End-to-End Push Notification Flow
- [ ] User registers device token on app launch
- [ ] Token appears in `push_tokens` table
- [ ] Backend sends notification on check-in event
- [ ] iOS app receives notification in foreground
- [ ] iOS app receives notification in background
- [ ] Tapping notification deep links to check-in
- [ ] User can disable notifications in Settings

### Realtime Subscription Flow
- [ ] User joins pack
- [ ] App subscribes to check-in updates for pack
- [ ] Teammate submits check-in
- [ ] Feed auto-updates without refresh
- [ ] Same for fine votes, comments, reactions
- [ ] Subscription cleanup on app backgrounding

### Upload Flow
- [ ] User captures photo with camera
- [ ] Image compresses to <500KB
- [ ] Image resizes to 1024px max
- [ ] Presigned URL requested successfully
- [ ] Upload to R2 completes
- [ ] Public URL returned and displayed
- [ ] Image loads on check-in card

---

## 🔗 RELATED DOCUMENTATION

- **Main Implementation Plan:** `docs/plans/2025-10-23-pakkt-ios-complete-build.md`
- **Service Layer Status:** `docs/plans/SERVICE_LAYER_STATUS.md`
- **Skipped Tasks:** `docs/plans/jail-screen-time-task-7.2-skipped.md`

---

## 📞 NEXT STEPS

1. **Review this audit** with team
2. **Prioritize Phase 1** (APNs + Realtime) - 1 day work
3. **Assign Phase 2** (Tests + Onboarding) - 2 days work
4. **Plan Phase 3** (Optimization) - Future sprint

**Estimated Total Effort:**
- Phase 1: **6 hours** (critical)
- Phase 2: **10 hours** (high priority)
- Phase 3: **6 hours** (nice to have)

**Total:** ~22 hours to production-ready state

---

**Last Updated:** 2025-10-24
**Next Review:** After Phase 1 completion
