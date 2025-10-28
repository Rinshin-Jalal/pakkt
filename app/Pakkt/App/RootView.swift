import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var hasCompletedOnboarding = false
    @State private var isAuthenticated = false

    var body: some View {
        if !hasCompletedOnboarding {
            OnboardingFlowView(onComplete: {
                hasCompletedOnboarding = true
            })
        } else if !isAuthenticated {
            NavigationStack(path: $coordinator.authPath) {
                NavigationFactory.createView(for: .auth)
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        NavigationFactory.createView(for: destination)
                    }
            }
        } else {
            TabView(selection: $coordinator.selectedTab) {
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
}
