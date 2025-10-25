# iOS Deep Linking Implementation Guide

**Status:** ✅ Complete and Ready for Testing
**Last Updated:** 2025-10-25

---

## Overview

The iOS app has a complete deep linking system that automatically navigates users to the appropriate screen when they tap on push notifications. The system supports all notification types sent by the backend.

---

## Architecture

### Components

1. **PushNotificationManager** - Central hub for push notifications
   - File: `app/Pakkt/Core/Services/PushNotificationManager.swift`
   - Implements `UNUserNotificationCenterDelegate`
   - Handles foreground and background notifications
   - Triggers deep linking

2. **DeepLinkHandler** - Parses notification payloads
   - File: `app/Pakkt/Core/Navigation/DeepLinkHandler.swift`
   - Extracts type and ID from notification data
   - Supports multiple payload formats
   - Returns typed `DeepLink` enum

3. **AppCoordinator** - Navigation orchestration
   - File: `app/Pakkt/Core/Navigation/AppCoordinator.swift`
   - Manages tab selection and navigation paths
   - Executes deep link navigation
   - Switches tabs and pushes views as needed

4. **AppDelegate** - System integration
   - File: `app/Pakkt/Core/Services/AppDelegate.swift`
   - Receives device tokens
   - Forwards remote notifications to manager

---

## Supported Deep Links

| Deep Link Type | Notification Type | Navigation Destination |
|----------------|-------------------|------------------------|
| `.checkIn(id)` | `check_in` | Feed → Check-in Detail |
| `.comment(checkInId)` | `comment` | Feed → Check-in Detail (with comments) |
| `.reaction(checkInId)` | `reaction` | Feed → Check-in Detail (with reactions) |
| `.fine(id)` | `fine` | Packs → Fine Detail |
| `.goal(id)` | `goal` | Packs → Goal Detail |
| `.pack(id)` | `pack` | Packs → Pack Detail |
| `.jailSession(id)` | `jail` | Packs → Jail Session Detail |
| `.feed` | N/A | Feed Tab |
| `.profile` | N/A | Profile Tab |

---

## Backend Notification Format

### APNs Payload Structure

The backend sends notifications with this structure:

```json
{
  "aps": {
    "alert": {
      "title": "John checked in! 🔥",
      "body": "Morning Workout"
    },
    "sound": "default",
    "badge": 1
  },
  "type": "check_in",
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "pack_id": "660e8400-e29b-41d4-a716-446655440001"
}
```

### Notification Types from Backend

| Backend Type | iOS Deep Link | Description |
|--------------|---------------|-------------|
| `check_in` | `.checkIn(id)` | Someone checked in to a goal |
| `comment` | `.comment(checkInId)` | New comment on check-in |
| `reaction` | `.reaction(checkInId)` | New reaction on check-in |
| `fine` | `.fine(id)` | Fine created, resolved, or appealed |
| `goal` | `.goal(id)` | Goal reminder or update |
| `pack` | `.pack(id)` | Pack invitation or update |
| `jail` or `jail_session` | `.jailSession(id)` | Jail session event |

---

## Flow Diagram

```
┌──────────────────┐
│  Push Received   │
│   (Background)   │
└────────┬─────────┘
         │
         ▼
┌──────────────────────────┐
│  AppDelegate             │
│  didReceiveRemoteNotif   │
└────────┬─────────────────┘
         │
         ▼
┌──────────────────────────┐
│  PushNotificationManager │
│  handleNotification()    │
└────────┬─────────────────┘
         │
         ▼
┌──────────────────────────┐
│  DeepLinkHandler         │
│  handle(userInfo)        │
│  → Parse type & id       │
│  → Return DeepLink enum  │
└────────┬─────────────────┘
         │
         ▼
┌──────────────────────────┐
│  AppCoordinator          │
│  handleDeepLink()        │
│  → Switch tab            │
│  → Push to navigation    │
└──────────────────────────┘
         │
         ▼
┌──────────────────────────┐
│  User sees detail screen │
└──────────────────────────┘
```

---

## Implementation Details

### 1. PushNotificationManager

**Setup:**
```swift
// In PakktApp.swift
@StateObject private var pushNotificationManager = PushNotificationManager.shared

var body: some Scene {
    WindowGroup {
        RootView()
            .onAppear {
                // Set coordinator for deep linking
                pushNotificationManager.setAppCoordinator(coordinator)

                // Request permission
                Task {
                    let granted = await pushNotificationManager.requestPermission()
                    if granted {
                        pushNotificationManager.registerForPushNotifications()
                    }
                }
            }
    }
}
```

**Key Methods:**
- `requestPermission()` - Request notification permissions
- `registerForPushNotifications()` - Register for remote notifications
- `handleDeviceToken(_:)` - Send token to backend
- `handleNotification(userInfo:isForeground:)` - Process notification and trigger deep link

### 2. DeepLinkHandler

**Payload Parsing:**
```swift
func handle(userInfo: [AnyHashable: Any]) -> DeepLink? {
    // Extract from root level (APNs format)
    var type: String? = userInfo["type"] as? String
    var idString: String? = userInfo["id"] as? String

    // Fallback to 'data' object if needed
    if type == nil || idString == nil {
        if let data = userInfo["data"] as? [String: Any] {
            type = data["type"] as? String
            idString = data["id"] as? String
        }
    }

    // Map to DeepLink enum
    switch type {
    case "check_in", "checkin":
        return .checkIn(id: UUID(uuidString: idString)!)
    case "comment":
        return .comment(checkInId: UUID(uuidString: idString)!)
    // ... more cases
    }
}
```

**Features:**
- Handles both root-level and nested `data` object formats
- Supports underscore (`check_in`) and camelCase (`checkIn`) types
- Type-safe UUID parsing
- Returns `nil` for invalid payloads

### 3. AppCoordinator

**Deep Link Navigation:**
```swift
func handleDeepLink(_ deepLink: DeepLink) {
    switch deepLink {
    case .checkIn(let id):
        selectedTab = 0  // Switch to Feed tab
        feedPath.append(NavigationDestination.checkInDetail(id: id.uuidString))

    case .fine(let id):
        selectedTab = 1  // Switch to Packs tab
        packsPath.append(NavigationDestination.fineDetail(id: id.uuidString))

    // ... more cases
    }
}
```

**Features:**
- Automatic tab switching
- Navigation path management
- Type-safe destination routing

---

## Testing Guide

### Test Scenario 1: Check-In Notification

**Backend Trigger:**
```bash
POST /api/checkins
Authorization: Bearer <user_token>

{
  "goal_id": "<goal_uuid>",
  "proof_url": "https://r2.pakkt.app/proof/image.jpg"
}
```

**Expected Notification:**
```json
{
  "aps": {
    "alert": {
      "title": "Alice checked in! 🔥",
      "body": "Morning Workout"
    },
    "sound": "default"
  },
  "type": "check_in",
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "pack_id": "660e8400-e29b-41d4-a716-446655440001"
}
```

**Expected Behavior:**
1. ✅ Notification appears on device
2. ✅ User taps notification
3. ✅ App opens (or comes to foreground)
4. ✅ App switches to Feed tab
5. ✅ Check-in detail screen opens
6. ✅ Shows check-in with ID `550e8400-e29b-41d4-a716-446655440000`

**Debug Logs to Verify:**
```
👆 [Push] User TAPPED notification
👆 [Push] Title: Alice checked in! 🔥
👆 [Push] Body: Morning Workout
📩 [Push] Handling notification
📩 [Push] UserInfo: {type: "check_in", id: "550e8400-e29b-41d4-a716-446655440000", ...}
🔗 [DeepLink] Found: checkIn(id: 550e8400-e29b-41d4-a716-446655440000)
🔗 [DeepLink] Navigating via coordinator
```

### Test Scenario 2: Comment Notification

**Backend Trigger:**
```bash
POST /api/social/comments
Authorization: Bearer <user_token>

{
  "check_in_id": "<check_in_uuid>",
  "content": "Great job! Keep it up 💪"
}
```

**Expected Notification:**
```json
{
  "aps": {
    "alert": {
      "title": "Bob commented 💬",
      "body": "Great job! Keep it up 💪"
    }
  },
  "type": "comment",
  "id": "440e8400-e29b-41d4-a716-446655440000"
}
```

**Expected Behavior:**
1. ✅ Notification appears
2. ✅ User taps notification
3. ✅ App opens to Feed tab
4. ✅ Check-in detail opens (showing the commented check-in)
5. ✅ Comments section visible

### Test Scenario 3: Fine Notification

**Backend Trigger:**
```bash
POST /api/fines
Authorization: Bearer <pack_creator_token>

{
  "pack_id": "<pack_uuid>",
  "user_id": "<user_uuid>",
  "goal_id": "<goal_uuid>",
  "amount": 500
}
```

**Expected Notification:**
```json
{
  "aps": {
    "alert": {
      "title": "Fine Issued: $5.00",
      "body": "Charlie missed a check-in. Vote now!"
    }
  },
  "type": "fine",
  "id": "770e8400-e29b-41d4-a716-446655440000",
  "pack_id": "660e8400-e29b-41d4-a716-446655440001"
}
```

**Expected Behavior:**
1. ✅ Notification appears
2. ✅ User taps notification
3. ✅ App switches to Packs tab
4. ✅ Fine detail screen opens
5. ✅ Shows voting interface

---

## Debugging

### Enable Verbose Logging

The implementation already includes comprehensive logging with emojis for easy filtering:

- `📩 [Push]` - Notification handling
- `👆 [Push]` - User tap events
- `📱 [Push]` - Foreground notifications
- `🔗 [DeepLink]` - Deep link parsing and navigation
- `⚠️ [DeepLink]` - Warnings and errors

### Common Issues

#### Issue 1: "App coordinator not set"
```
⚠️ [DeepLink] App coordinator not set, cannot navigate
```

**Cause:** `PushNotificationManager.setAppCoordinator()` not called
**Fix:** Ensure `PakktApp.swift` calls `setAppCoordinator()` in `.onAppear`

#### Issue 2: "No deep link found in notification"
```
⚠️ [DeepLink] No deep link found in notification
```

**Cause:** Notification payload missing `type` or `id` fields
**Fix:** Check backend notification template includes these fields

#### Issue 3: Navigation not happening

**Possible Causes:**
1. Invalid UUID format in `id` field
2. Type mismatch (backend sends `check_in`, iOS expects `checkin`)
3. Missing navigation destination in AppCoordinator

**Debug Steps:**
1. Check logs for parsed deep link type
2. Verify `DeepLinkHandler.handle(userInfo:)` returns non-nil
3. Ensure `AppCoordinator.handleDeepLink()` has case for the type

### Testing with Xcode Console

Filter console output:
```
📩  - See all notification handling
🔗  - See all deep link processing
⚠️  - See all warnings/errors
```

---

## Notification Permissions

### Request Flow

```swift
// Automatic on app launch (in PakktApp.swift)
let granted = await pushNotificationManager.requestPermission()

if granted {
    // User granted permission
    pushNotificationManager.registerForPushNotifications()
} else {
    // User denied permission
    // Show educational UI or settings link
}
```

### Permission States

| State | Description | Action |
|-------|-------------|--------|
| `notDetermined` | First launch | Request permission |
| `authorized` | Permission granted | Register for notifications |
| `denied` | User denied | Show Settings link |
| `provisional` | Silent notifications only | Request full permission |

### Check Current Status

```swift
let status = await notificationService.checkAuthorizationStatus()

switch status {
case .authorized:
    print("✅ Ready for push notifications")
case .denied:
    print("❌ User denied permission - show Settings link")
case .notDetermined:
    print("⏳ Need to request permission")
default:
    print("⚠️ Unexpected status: \(status)")
}
```

---

## Settings Integration (Future)

### Notification Preferences Screen

**Location:** Profile → Settings → Notifications

**Features:**
- Toggle notifications on/off
- Choose notification types (check-ins, fines, comments, etc.)
- Set quiet hours
- Test notification button

**Implementation:**
```swift
struct NotificationSettingsView: View {
    @State private var notificationsEnabled = true

    var body: some View {
        Form {
            Section {
                Toggle("Enable Push Notifications", isOn: $notificationsEnabled)
                    .onChange(of: notificationsEnabled) { newValue in
                        if newValue {
                            Task {
                                await enableNotifications()
                            }
                        } else {
                            Task {
                                await disableNotifications()
                            }
                        }
                    }
            }

            Section("Notification Types") {
                Toggle("Check-ins", isOn: .constant(true))
                Toggle("Fines & Voting", isOn: .constant(true))
                Toggle("Comments", isOn: .constant(true))
                Toggle("Reactions", isOn: .constant(true))
            }

            Section {
                Button("Test Notification") {
                    // Schedule local test notification
                }
            }
        }
    }

    private func enableNotifications() async {
        let granted = await PushNotificationManager.shared.requestPermission()
        if granted {
            PushNotificationManager.shared.registerForPushNotifications()
        }
    }

    private func disableNotifications() async {
        try? await PushNotificationManager.shared.notificationService.unregisterDeviceToken()
    }
}
```

---

## Next Steps

### Immediate
- ✅ Deep linking implemented
- ⏳ Test with real APNs credentials
- ⏳ Verify all notification types

### Short-term
- [ ] Add notification settings UI
- [ ] Handle "denied" permission state
- [ ] Add notification preferences backend
- [ ] Implement quiet hours

### Long-term
- [ ] Rich notifications with images
- [ ] Notification action buttons
- [ ] Notification categories with custom actions
- [ ] Analytics for notification engagement

---

## Related Documentation

- APNs Backend Implementation: `backend/tests/apns-testing.md`
- iOS Architecture: `docs/ios-architecture.md`
- Navigation System: `app/Pakkt/Core/Navigation/README.md` (if exists)
- Backend Notification Templates: `backend/src/features/notifications/templates.ts`

---

**Questions or Issues?**
File an issue at: https://github.com/your-repo/pakkt/issues

**Last Updated:** 2025-10-25
**Version:** 1.0.0
