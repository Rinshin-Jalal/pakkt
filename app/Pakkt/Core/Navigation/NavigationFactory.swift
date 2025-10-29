import SwiftUI

struct NavigationFactory {
    @ViewBuilder
    static func createView(for destination: NavigationDestination) -> some View {
        destination.view
    }
}

// MARK: - Onboarding Step Wrapper

struct OnboardingStepWrapper: View {
    let step: Int
    
    var body: some View {
        Group {
            switch step {
            case 1:
                OnboardingStep1View(onContinue: {})
            case 2:
                OnboardingStep2View(onContinue: {})
            case 3:
                OnboardingStep3View(onContinue: {})
            case 4:
                OnboardingStep4View(onContinue: {})
            case 5:
                OnboardingStep5View(onContinue: {})
            case 6:
                OnboardingStep6View(onContinue: {})
            case 7:
                OnboardingStep7View(onContinue: {})
            case 8:
                OnboardingStep8View(onContinue: {})
            case 9:
                OnboardingStep9View { goalText in
                    // Handle the goal text if needed
                }
            case 10:
                OnboardingStep10View(goal: "Default Goal", onContinue: { _, _ in
                    // Handle the impact values if needed
                })
            case 11:
                OnboardingStep11View(goal: "Default Goal", onContinue: { _ in
                    // Handle the cost value if needed
                })
            case 12:
                OnboardingStep12View(onContinue: {})
            case 13:
                OnboardingStep13View(onContinue: {})
            case 14:
                OnboardingStep14View(commitmentStyle: .constant(""), onContinue: {})
            case 15:
                OnboardingStep15View(successVision: .constant(""), onContinue: {})
            case 16:
                OnboardingStep16View(selectedGoal: "Default", selectedWhy: "Default", estimatedCost: 16.0, onContinue: {})
            case 17:
                OnboardingStep17View(onContinue: {})
            case 18:
                OnboardingStep18View(onContinue: {})
            case 19:
                OnboardingStep19View(onContinue: {})
            case 20:
                OnboardingStep20View(onContinue: {})
            case 21:
                OnboardingStep21View(onContinue: {})
            case 22:
                OnboardingStep22View(onContinue: {})
            case 23:
                OnboardingStep23View(onContinue: {})
            case 24:
                OnboardingStep24View(onContinue: {})
            case 25:
                OnboardingStep25View(onContinue: {})
            case 26:
                OnboardingStep26View(onContinue: {})
            case 27:
                OnboardingStep27View(onContinue: {})
            case 28:
                OnboardingStep28View(onContinue: {})
            case 29:
                OnboardingStep29View(onContinue: {})
            case 30:
                OnboardingStep30View(onContinue: {})
            case 31:
                OnboardingStep31View(onContinue: {})
            case 32:
                OnboardingStep32View(onContinue: {})
            case 33:
                OnboardingStep33View(onContinue: {})
            default:
                Text("Onboarding Step \(step)").font(.largeTitle)
            }
        }
    }
}

extension NavigationDestination {
    @ViewBuilder
    var view: some View {
        switch self {
        case .auth: AuthView()
        case .signUp: Text("Sign Up - Coming Soon").font(.largeTitle)
        case .forgotPassword: Text("Forgot Password - Coming Soon").font(.largeTitle)
        case .onboarding: OnboardingFlowView(onComplete: {})
        case .onboardingStep(let step): OnboardingStepWrapper(step: step)
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
