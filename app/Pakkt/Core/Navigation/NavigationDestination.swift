import Foundation

enum NavigationDestination: Hashable {
    // Auth Flow
    case auth
    case signUp
    case forgotPassword

    // Onboarding Flow
    case onboarding
    case onboardingStep(Int)

    // Feed Flow
    case feed
    case postDetail(id: String)
    case comments(postId: String)

    // Packs Flow
    case packList
    case packDetail(id: String)
    case createPack
    case editPack(id: String)
    case taskDetail(id: String)

    // Profile Flow
    case profile
    case editProfile
    case settings
    case about

    // Check-in and Notification Flow
    case checkInDetail(id: String)
    case fineDetail(id: String)
    case goalDetail(id: String)
    case packNotification(id: String)
}
