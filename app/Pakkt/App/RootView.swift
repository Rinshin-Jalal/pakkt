import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var isAuthenticated = true  // Set to true for UI testing
    @State private var hasCompletedOnboarding = true  // Set to true for UI testing

    var body: some View {
        Group {
            if !isAuthenticated {
                NavigationStack(path: $coordinator.authPath) {
                    NavigationFactory.createView(for: .auth)
                        .navigationDestination(for: NavigationDestination.self) { destination in
                            NavigationFactory.createView(for: destination)
                        }
                }
            } else if !hasCompletedOnboarding {
                NavigationStack(path: $coordinator.onboardingPath) {
                    NavigationFactory.createView(for: .onboarding)
                        .navigationDestination(for: NavigationDestination.self) { destination in
                            NavigationFactory.createView(for: destination)
                        }
                }
            } else {
                TabView(selection: $coordinator.selectedTab) {
                    // Tab 1: Feed (Your Pack's Check-ins)
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

                    // Tab 2: Profile
                    NavigationStack(path: $coordinator.profilePath) {
                        NavigationFactory.createView(for: .profile)
                            .navigationDestination(for: NavigationDestination.self) { destination in
                                NavigationFactory.createView(for: destination)
                            }
                    }
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(1)
                }
            }
        }
        .onAppear {
            checkAuthStatus()
        }
    }

    private func checkAuthStatus() {
        // TODO: Check Supabase auth status
        // For now, default to unauthenticated
    }
}
