import SwiftUI

struct NavigationFactory {
    @ViewBuilder
    static func createView(for destination: NavigationDestination) -> some View {
        destination.view
    }
}

extension NavigationDestination {
    @ViewBuilder
    var view: some View {
        switch self {
        case .auth: Text("Auth Screen").font(.largeTitle)
        case .signUp: Text("Sign Up Screen").font(.largeTitle)
        case .forgotPassword: Text("Forgot Password Screen").font(.largeTitle)
        case .onboarding: Text("Onboarding Screen").font(.largeTitle)
        case .onboardingStep(let step): Text("Onboarding Step \(step)").font(.largeTitle)
        case .feed: FeedView()
        case .postDetail(let id): Text("Post Detail: \(id)").font(.largeTitle)
        case .comments(let postId): Text("Comments for Post: \(postId)").font(.largeTitle)
        case .packList: Text("Pack List Screen").font(.largeTitle)
        case .packDetail(let id): Text("Pack Detail: \(id)").font(.largeTitle)
        case .createPack: Text("Create Pack Screen").font(.largeTitle)
        case .editPack(let id): Text("Edit Pack: \(id)").font(.largeTitle)
        case .taskDetail(let id): Text("Task Detail: \(id)").font(.largeTitle)
        case .profile: Text("Profile Screen").font(.largeTitle)
        case .editProfile: Text("Edit Profile Screen").font(.largeTitle)
        case .settings: NotificationSettingsView()
        case .about: Text("About Screen").font(.largeTitle)
        case .checkInDetail(let id): Text("Check-in Detail: \(id)").font(.largeTitle)
        case .fineDetail(let id): Text("Fine Detail: \(id)").font(.largeTitle)
        case .goalDetail(let id): Text("Goal Detail: \(id)").font(.largeTitle)
        case .packNotification(let id): Text("Pack Notification: \(id)").font(.largeTitle)
        }
    }
}
