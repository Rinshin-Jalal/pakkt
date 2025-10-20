import SwiftUI
import Combine

@MainActor
class AppCoordinator: ObservableObject {
    // Tab Selection
    @Published var selectedTab = 0

    // Navigation Paths for each flow
    @Published var authPath = NavigationPath()
    @Published var onboardingPath = NavigationPath()
    @Published var feedPath = NavigationPath()
    @Published var packsPath = NavigationPath()
    @Published var profilePath = NavigationPath()

    // MARK: - Auth Navigation

    func showAuth() {
        authPath = NavigationPath()
    }

    func showSignUp() {
        authPath.append(NavigationDestination.signUp)
    }

    func showForgotPassword() {
        authPath.append(NavigationDestination.forgotPassword)
    }

    // MARK: - Onboarding Navigation

    func startOnboarding() {
        onboardingPath = NavigationPath()
    }

    func showOnboardingStep(_ step: Int) {
        onboardingPath.append(NavigationDestination.onboardingStep(step))
    }

    // MARK: - Feed Navigation

    func showFeed() {
        selectedTab = 0
        feedPath = NavigationPath()
    }

    func showPostDetail(id: String) {
        feedPath.append(NavigationDestination.postDetail(id: id))
    }

    func showComments(postId: String) {
        feedPath.append(NavigationDestination.comments(postId: postId))
    }

    // MARK: - Packs Navigation

    func showPackList() {
        selectedTab = 1
        packsPath = NavigationPath()
    }

    func showPackDetail(id: String) {
        packsPath.append(NavigationDestination.packDetail(id: id))
    }

    func showCreatePack() {
        packsPath.append(NavigationDestination.createPack)
    }

    func showEditPack(id: String) {
        packsPath.append(NavigationDestination.editPack(id: id))
    }

    func showTaskDetail(id: String) {
        packsPath.append(NavigationDestination.taskDetail(id: id))
    }

    // MARK: - Profile Navigation

    func showProfile() {
        selectedTab = 2
        profilePath = NavigationPath()
    }

    func showEditProfile() {
        profilePath.append(NavigationDestination.editProfile)
    }

    func showSettings() {
        profilePath.append(NavigationDestination.settings)
    }

    func showAbout() {
        profilePath.append(NavigationDestination.about)
    }

    // MARK: - Global Navigation

    func popToRoot(for tab: Int) {
        switch tab {
        case 0:
            feedPath = NavigationPath()
        case 1:
            packsPath = NavigationPath()
        case 2:
            profilePath = NavigationPath()
        default:
            break
        }
    }

    func pop() {
        switch selectedTab {
        case 0:
            if !feedPath.isEmpty {
                feedPath.removeLast()
            }
        case 1:
            if !packsPath.isEmpty {
                packsPath.removeLast()
            }
        case 2:
            if !profilePath.isEmpty {
                profilePath.removeLast()
            }
        default:
            break
        }
    }
}
