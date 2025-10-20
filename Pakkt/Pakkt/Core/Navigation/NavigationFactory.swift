import SwiftUI

struct NavigationFactory {
    @ViewBuilder
    static func createView(for destination: NavigationDestination) -> some View {
        switch destination {
        // Auth Flow
        case .auth:
            Text("Auth Screen")
                .font(.largeTitle)
        case .signUp:
            Text("Sign Up Screen")
                .font(.largeTitle)
        case .forgotPassword:
            Text("Forgot Password Screen")
                .font(.largeTitle)

        // Onboarding Flow
        case .onboarding:
            Text("Onboarding Screen")
                .font(.largeTitle)
        case .onboardingStep(let step):
            Text("Onboarding Step \(step)")
                .font(.largeTitle)

        // Feed Flow
        case .feed:
            Text("Feed Screen")
                .font(.largeTitle)
        case .postDetail(let id):
            Text("Post Detail: \(id)")
                .font(.largeTitle)
        case .comments(let postId):
            Text("Comments for Post: \(postId)")
                .font(.largeTitle)

        // Packs Flow
        case .packList:
            Text("Pack List Screen")
                .font(.largeTitle)
        case .packDetail(let id):
            Text("Pack Detail: \(id)")
                .font(.largeTitle)
        case .createPack:
            Text("Create Pack Screen")
                .font(.largeTitle)
        case .editPack(let id):
            Text("Edit Pack: \(id)")
                .font(.largeTitle)
        case .taskDetail(let id):
            Text("Task Detail: \(id)")
                .font(.largeTitle)

        // Profile Flow
        case .profile:
            Text("Profile Screen")
                .font(.largeTitle)
        case .editProfile:
            Text("Edit Profile Screen")
                .font(.largeTitle)
        case .settings:
            Text("Settings Screen")
                .font(.largeTitle)
        case .about:
            Text("About Screen")
                .font(.largeTitle)
        }
    }
}
