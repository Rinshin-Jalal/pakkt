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
}
