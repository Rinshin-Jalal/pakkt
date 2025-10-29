import SwiftUI
import Combine

@MainActor
class AppCoordinator: ObservableObject {
    // Authentication State
    @Published var isAuthenticated = false
    @AppStorage("hasCompletedOnboarding") var isFirstLaunch = true
    
    // Tab Selection
    @Published var selectedTab = 0

    // Navigation Paths for each flow
    @Published var authPath = NavigationPath()
    @Published var onboardingPath = NavigationPath()
    @Published var feedPath = NavigationPath()
    @Published var packsPath = NavigationPath()
    @Published var profilePath = NavigationPath()
    
    private let authViewModel = AuthViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Subscribe to authentication changes
        authViewModel.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                self?.isAuthenticated = isAuthenticated
                if isAuthenticated {
                    self?.showMainApp()
                }
            }
            .store(in: &cancellables)
        
        // Check initial authentication status
        Task {
            await authViewModel.checkAuthStatus()
        }
    }

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
    
    // MARK: - Authentication Flow
    
    func handleAuthenticationSuccess() {
        // Clear auth path and show main app
        authPath = NavigationPath()
        showMainApp()
    }
    
    func handleAuthenticationRequired() {
        // Show auth screen
        showAuth()
    }
    
    func signOut() {
        Task {
            await authViewModel.signOut()
            // Clear all navigation paths
            authPath = NavigationPath()
            onboardingPath = NavigationPath()
            feedPath = NavigationPath()
            packsPath = NavigationPath()
            profilePath = NavigationPath()
            selectedTab = 0
            // Show auth screen
            showAuth()
        }
    }
    
    private func showMainApp() {
        // Check if user needs onboarding
        if isFirstLaunch {
            startOnboarding()
        } else {
            // Show main app (feed by default)
            showFeed()
        }
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

    // MARK: - Notification Deep Link Navigation

    func showCheckInDetail(id: String) {
        // Navigate to check-in detail
        selectedTab = 0 // Feed tab
        feedPath.append(NavigationDestination.checkInDetail(id: id))
    }

    func showFineDetail(id: String) {
        // Navigate to fine detail
        selectedTab = 1 // Pack tab
        packsPath.append(NavigationDestination.fineDetail(id: id))
    }

    func showGoalDetail(id: String) {
        // Navigate to goal detail
        selectedTab = 1 // Pack tab
        packsPath.append(NavigationDestination.goalDetail(id: id))
    }

    func showPackNotification(id: String) {
        // Navigate to pack notification
        selectedTab = 1 // Pack tab
        packsPath.append(NavigationDestination.packNotification(id: id))
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

    // MARK: - Deep Link Handling

    func handleDeepLink(_ deepLink: DeepLink) {
        switch deepLink {
        case .pack(let id):
            showPackDetail(id: id.uuidString)
        case .goal(let id):
            showGoalDetail(id: id.uuidString)
        case .checkIn(let id):
            showCheckInDetail(id: id.uuidString)
        case .fine(let id):
            showFineDetail(id: id.uuidString)
        case .jailSession(let id):
            // Navigate to jail session detail
            selectedTab = 1 // Pack tab
            packsPath.append(NavigationDestination.taskDetail(id: id.uuidString))
        case .comment(let checkInId):
            // Navigate to check-in detail (comments are shown there)
            showCheckInDetail(id: checkInId.uuidString)
        case .reaction(let checkInId):
            // Navigate to check-in detail (reactions are shown there)
            showCheckInDetail(id: checkInId.uuidString)
        case .feed:
            showFeed()
        case .profile:
            showProfile()
        }
    }
}
