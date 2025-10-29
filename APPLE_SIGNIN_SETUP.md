# Apple Sign In Setup Instructions

## Issue
You're seeing the error: `Authorization failed: Error Domain=AKAuthenticationError Code=-7026` because Sign in with Apple is not properly configured.

## Setup Steps

### 1. Add Sign in with Apple Capability in Xcode

1. Open `Pakkt.xcodeproj` in Xcode
2. Select the **Pakkt** target in the project navigator
3. Go to the **Signing & Capabilities** tab
4. Click **+ Capability** button
5. Search for and add **Sign in with Apple**
6. The `Pakkt.entitlements` file will be automatically linked (already created at `/app/Pakkt/Pakkt.entitlements`)

### 2. Configure Apple Developer Account

#### For Real Device Testing:
1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Select your app identifier (`com.rinshinjalal.pakkt.Pakkt`)
4. Under **Capabilities**, enable **Sign in with Apple**
5. Save the changes

#### For Simulator Testing:
Sign in with Apple requires additional setup for simulator:

1. **On your Mac**: 
   - Go to **System Preferences** → **Apple ID** → **Password & Security**
   - Make sure you're signed in with your Apple ID

2. **In Simulator**:
   - Open **Settings** app
   - Sign in with the same Apple ID
   - The simulator will now be able to use Sign in with Apple

### 3. Update Provisioning Profile

After enabling the capability:
1. In Xcode, go to **Signing & Capabilities**
2. Click **Download Manual Profiles** (if using manual signing)
3. Or let Xcode automatically manage signing by checking **Automatically manage signing**

### 4. Supabase Configuration

Make sure your Supabase project has Apple OAuth configured:
1. Go to your Supabase project dashboard
2. Navigate to **Authentication** → **Providers**
3. Enable **Apple** provider
4. Add your **Service ID** (Bundle ID: `com.rinshinjalal.pakkt.Pakkt`)
5. Configure the redirect URL

### 5. Test on Real Device

For the most reliable testing:
1. Connect your iPhone to your Mac
2. Select your device as the build destination in Xcode
3. Run the app
4. Sign in with Apple should work without errors

## Common Issues

### Simulator Errors
- **Code -7026**: Simulator not signed in with Apple ID
- **Code 1000**: Generic simulator auth error - try restarting simulator or testing on device

### Solution for Simulator
1. Quit the simulator completely
2. Sign out and back in to your Apple ID on your Mac
3. Restart Xcode
4. Run the app again

### Best Practice
**Always test Sign in with Apple on a real device for production-ready testing.**

## Current Status
✅ Entitlements file created: `Pakkt.entitlements`
⚠️  Need to add capability in Xcode project
⚠️  Need to configure in Apple Developer Portal
⚠️  Need to sign in to Apple ID in Simulator (for simulator testing)
