import Foundation
import SwiftUI
import Combine

@MainActor
class ProfileViewModel: BaseViewModel {
    @Published var profile: UserProfile?
    
    private let usersService: UsersService
    let notificationSettingsViewModel: NotificationSettingsViewModel

    init(usersService: UsersService = UsersService()) {
        self.usersService = usersService
        self.notificationSettingsViewModel = NotificationSettingsViewModel()
        super.init()
    }

    func loadProfile() async {
        do {
            let profile = try await withLoading {
                try await self.usersService.getProfile()
            }
            self.profile = profile
        } catch {
            handleError(error)
        }
    }

    func updateProfile(username: String? = nil, profilePic: String? = nil, bio: String? = nil) async {
        do {
            let request = UpdateProfileRequest(
                username: username,
                profilePic: profilePic,
                bio: bio
            )

            let updatedProfile = try await withLoading {
                try await self.usersService.updateProfile(request)
            }

            self.profile = updatedProfile
        } catch {
            handleError(error)
        }
    }
    
    func registerPushToken(_ token: String) async {
        do {
            // Get device ID (use identifierForVendor or generate UUID)
            let deviceId = await UIDevice.current.identifierForVendor?.uuidString
            
            try await usersService.registerPushToken(
                token: token,
                deviceType: "ios",
                deviceId: deviceId
            )
            
            print("✅ Push token registered successfully")
        } catch {
            print("❌ Failed to register push token: \(error)")
            // Don't show error to user for push token registration
            // It's a background operation
        }
    }
    
    func unregisterPushToken() async {
        do {
            try await usersService.deletePushToken()
            print("✅ Push token unregistered successfully")
        } catch {
            print("❌ Failed to unregister push token: \(error)")
        }
    }
}
