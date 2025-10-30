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
            // ACT 1: HOOK
            case 1: WelcomeToPacktView(onContinue: {})
            case 2: WhatIsPackView(onContinue: {})
            
            // ACT 2: PAIN
            case 3: GoalFailureInputView(onContinue: {}, goalName: .constant(""))
            case 4: WhyWillpowerFailsView(onContinue: {})
            case 5: FailurePatternView(onContinue: {}, failureCount: .constant(15))
            case 6: FailedApproachesVisualView(onContinue: {})
            case 7: WhatYouveTriedView(onContinue: {}, failedApproaches: .constant([]))
            case 8: EmotionalImpactView(onContinue: {}, emotionalImpact: .constant(""))
            case 9: SuccessVisionView(onContinue: {}, successVision: .constant(""))
            
            // ACT 3: RELIEF
            case 10: ConsequencesVsWillpowerView(onContinue: {})
            case 11: HowPacktWorksView(onContinue: {})
            case 12: LivePackExampleView(onContinue: {})
            case 13: BrotherhoodFeaturesView(onContinue: {})
            
            // ACT 4: BRIDGE
            case 14: ValuePropositionView(onContinue: {})
            
            // ACT 5: BUILD
            case 15: PackFoundationView(onContinue: {})
            case 16: PackIdentityView(onContinue: {})
            case 17: GoalsCreationView(onContinue: {})
            case 18: PackRulesView(onContinue: {})
            case 19: PackConsequencesView(onContinue: {})
            case 20: PackPreviewView(onContinue: {})
            case 21: PackPactAgreementView(onContinue: {})
            case 22: SignPackPactView(onContinue: {})
            
            // ACT 6: URGENCY
            case 23: CountdownToFirstChallengeView(onContinue: {}, firstCheckInTime: .constant(Date()))
            
            // ACT 7: COMMIT
            case 24: PermissionsSetupView(onContinue: {})
            case 25: YourPackRealityView(
                onContinue: {},
                packName: .constant(""),
                packSize: .constant(5),
                goalName: .constant(""),
                cashFine: .constant(10),
                jailTimeMinutes: .constant(30)
            )
            case 26: PaywallView(onContinue: {})
            
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
