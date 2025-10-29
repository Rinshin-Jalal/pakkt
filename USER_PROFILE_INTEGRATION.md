# User Profile Management Integration

## Summary
Successfully integrated the UsersService with backend `/api/users/profile` endpoints and connected it to the ProfileView. Push token registration is also fully integrated.

## What Was Implemented

### 1. Backend Integration ✅

**UsersService** (`app/Pakkt/Features/Users/Services/UsersService.swift`)
- `getProfile()` → GET `/api/users/profile`
- `updateProfile()` → PATCH `/api/users/profile`
- `registerPushToken()` → POST `/api/users/push-token`
- `deletePushToken()` → DELETE `/api/users/push-token`

**Backend Endpoints** (`backend/src/features/users/router.ts`)
- GET `/api/users/profile` - Get current user profile
- PATCH `/api/users/profile` - Update user profile (username, bio, profile_pic)
- POST `/api/users/push-token` - Register iOS push notification token
- DELETE `/api/users/push-token` - Remove push notification token

### 2. ProfileViewModel ✅

**Features:**
- Loads user profile from backend on view appear
- Updates profile (username, bio, profile picture)
- Registers/unregisters push tokens
- Error handling and loading states
- Pull-to-refresh support

**Methods:**
```swift
func loadProfile() async
func updateProfile(username: String?, profilePic: String?, bio: String?) async
func registerPushToken(_ token: String) async
func unregisterPushToken() async
```

### 3. ProfileView ✅

**Features:**
- Displays real user data from backend
- Shows user stats (streak, check-ins, fines)
- Edit profile button → opens EditProfileView sheet
- Navigation to notification settings
- Sign out functionality
- Loading and error states
- Pull-to-refresh

**Data Displayed:**
- Profile picture (or initials fallback)
- Username
- Email
- Bio
- Current streak
- Total check-ins
- Total fines paid

### 4. EditProfileView ✅

**Features:**
- Edit username
- Edit bio (multi-line)
- Shows email (read-only)
- Profile picture preview
- Save changes to backend
- Loading state during save
- Cancel/Save buttons

### 5. Push Token Registration ✅

**Flow:**
1. App launches → `AppDelegate.didFinishLaunchingWithOptions`
2. Registers for remote notifications
3. Gets device token → `AppDelegate.didRegisterForRemoteNotificationsWithDeviceToken`
4. `PushNotificationManager.handleDeviceToken()`
5. `NotificationService.registerDeviceToken()`
6. `UsersService.registerPushToken()` → POST to backend

**Components:**
- `AppDelegate` - Handles device token registration
- `PushNotificationManager` - Manages push notification lifecycle
- `NotificationService` - Actor for notification operations
- `UsersService` - Sends token to backend API

## Files Created/Modified

### Created:
- `/app/Pakkt/Features/Profile/Views/EditProfileView.swift` - New edit profile screen

### Modified:
- `/app/Pakkt/Features/Profile/Views/ProfileView.swift` - Connected to backend
- `/app/Pakkt/Features/Profile/ViewModels/ProfileViewModel.swift` - Added push token methods
- `/app/Pakkt/Features/Users/Services/UsersService.swift` - Already had endpoints

### Existing (Already Working):
- `/app/Pakkt/Core/Services/AppDelegate.swift` - Push token handling
- `/app/Pakkt/Core/Services/PushNotificationManager.swift` - Token registration
- `/app/Pakkt/Core/Services/NotificationService.swift` - Calls UsersService
- `/app/Pakkt/Features/Users/Models/UserProfile.swift` - Data model
- `/app/Pakkt/Features/Users/Models/UpdateProfileRequest.swift` - Request model

## Data Flow

### Loading Profile:
```
ProfileView → ProfileViewModel.loadProfile() 
  → UsersService.getProfile() 
  → APIClient.request(PakktEndpoint.getProfile)
  → GET /api/users/profile
  → Backend returns UserProfile
  → Display in UI
```

### Updating Profile:
```
EditProfileView → Save Button
  → ProfileViewModel.updateProfile()
  → UsersService.updateProfile(UpdateProfileRequest)
  → APIClient.request(PakktEndpoint.updateProfile)
  → PATCH /api/users/profile
  → Backend returns updated UserProfile
  → UI updates automatically
  → Sheet dismisses
```

### Push Token Registration:
```
App Launch → AppDelegate.registerForPushNotifications()
  → iOS returns device token
  → PushNotificationManager.handleDeviceToken()
  → NotificationService.registerDeviceToken()
  → UsersService.registerPushToken()
  → POST /api/users/push-token
  → Backend stores token in database
```

## Testing Checklist

### Profile View
- [x] Loads profile data on appear
- [x] Shows loading indicator
- [x] Displays user info (name, email, bio)
- [x] Shows stats (streak, check-ins, fines)
- [x] Pull-to-refresh works
- [x] Error handling with retry

### Edit Profile
- [x] Opens sheet when clicking Edit Profile
- [x] Pre-fills current data
- [x] Saves changes to backend
- [x] Shows loading during save
- [x] Validates changes before saving
- [x] Dismisses on successful save

### Push Tokens
- [x] Registers token on app launch
- [x] Sends token to backend
- [x] Device ID included
- [x] Error handling (silent, logs only)

## Backend API Details

### GET /api/users/profile
**Response:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "username": "string",
    "email": "string",
    "phone_number": "string",
    "profile_pic": "url",
    "bio": "string",
    "subscription_status": "free|trial|pro",
    "total_xp": 0,
    "current_level": 0,
    "current_streak": 0,
    "longest_streak": 0,
    "total_checkins": 0,
    "total_fines_paid": 0,
    "total_jails_completed": 0,
    "created_at": "iso8601",
    "updated_at": "iso8601"
  }
}
```

### PATCH /api/users/profile
**Request:**
```json
{
  "username": "optional string",
  "bio": "optional string",
  "profile_pic": "optional url"
}
```

### POST /api/users/push-token
**Request:**
```json
{
  "token": "apns_device_token",
  "device_type": "ios",
  "device_id": "uuid"
}
```

## Notes

- Push token registration happens automatically in background
- Profile picture upload not yet implemented (placeholder for future)
- Privacy settings navigation is a TODO
- FAQ and support pages are TODOs
- All network calls use proper error handling
- Loading states prevent double-submissions
- Pull-to-refresh provides good UX

## Next Steps (Optional)

1. Add profile picture upload (presigned URL + S3)
2. Implement privacy settings page
3. Add FAQ and support pages
4. Add haptic feedback on actions
5. Add profile picture editing/cropping
6. Cache profile data locally
7. Add profile completion percentage
8. Add profile achievements/badges
