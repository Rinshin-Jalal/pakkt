import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        Group {
            // Show onboarding first if it's first launch
            if coordinator.isFirstLaunch {
                OnboardingFlowView(onComplete: {
                    // Mark onboarding as completed
                    coordinator.isFirstLaunch = false
                    // After onboarding, show paywall then auth
                    // For now, directly show auth
                    coordinator.handleAuthenticationRequired()
                })
            }
            // Show auth screen if not authenticated (after onboarding)
            else if !coordinator.isAuthenticated {
                NavigationStack(path: $coordinator.authPath) {
                    AuthView()
                        .environmentObject(coordinator)
                        .navigationDestination(for: NavigationDestination.self) { destination in
                            NavigationFactory.createView(for: destination)
                        }
                }
            }
            // Show main app if authenticated
            else {
                TabView(selection: $coordinator.selectedTab) {
                    // Feed Tab
                    NavigationStack(path: $coordinator.feedPath) {
                        NavigationFactory.createView(for: .feed)
                            .navigationDestination(for: NavigationDestination.self) { destination in
                                NavigationFactory.createView(for: destination)
                            }
                    }
                    .tabItem {
                        Label("Feed", systemImage: "house.fill")
                    }
                    .tag(0)

                    // Packs Tab
                    NavigationStack(path: $coordinator.packsPath) {
                        NavigationFactory.createView(for: .packList)
                            .navigationDestination(for: NavigationDestination.self) { destination in
                                NavigationFactory.createView(for: destination)
                            }
                    }
                    .tabItem {
                        Label("Packs", systemImage: "person.3.fill")
                    }
                    .tag(1)

                    // Profile Tab
                    NavigationStack(path: $coordinator.profilePath) {
                        NavigationFactory.createView(for: .profile)
                            .navigationDestination(for: NavigationDestination.self) { destination in
                                NavigationFactory.createView(for: destination)
                            }
                    }
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(2)
                }
            }
        }
        .onAppear {
            // Check initial authentication state
            Task {
                await checkInitialAuthState()
            }
        }
    }
    
    private func checkInitialAuthState() async {
        // If first launch, show onboarding first
        if coordinator.isFirstLaunch {
            return
        }
        
        // If not authenticated, show auth screen
        if !coordinator.isAuthenticated {
            coordinator.handleAuthenticationRequired()
        }
    }
}
