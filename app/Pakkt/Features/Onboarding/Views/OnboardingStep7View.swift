import SwiftUI

// MARK: - Step 7: Real Pack Examples
struct OnboardingStep7View: View {
    @State private var showContent = false
    let onContinue: () -> Void
    
    let examples: [PackActivity] = [
        PackActivity(
            packName: "Iron Wolves",
            userName: "Jake",
            action: "missed leg day",
            consequence: "1hr jail",
            status: .failed,
            members: "3/4 checked in",
            tintColor: Color(hex: "#FF3B30")
        ),
        PackActivity(
            packName: "Brain Trust",
            userName: "Sarah",
            action: "crushed chem study",
            consequence: "15-day streak",
            status: .success,
            members: "5/5 studied tonight",
            tintColor: Color(hex: "#0066FF")
        ),
        PackActivity(
            packName: "Sober Squad",
            userName: "Mike",
            action: "survived Tuesday sober",
            consequence: "Pack proud",
            status: .success,
            members: "4/4 stayed sober",
            tintColor: Color(hex: "#00D448")
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("LIVE PACK FEEDS")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                        .padding(.top, 20)
                    
                    Text("47,823 packs active right now")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .opacity(showContent ? 1 : 0)
                .padding(.bottom, 20)
                
                // Feed scroll
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(examples) { activity in
                            PackActivityCard(activity: activity)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 12)
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // Continue button
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("CONTINUE")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1.0)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                }
                .buttonStyle(.glass)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
        }
    }
}

// MARK: - Pack Activity Model
struct PackActivity: Identifiable {
    let id = UUID()
    let packName: String
    let userName: String
    let action: String
    let consequence: String
    let status: ActivityStatus
    let members: String
    let tintColor: Color
    
    enum ActivityStatus {
        case success, failed
    }
}

// MARK: - Pack Activity Card
struct PackActivityCard: View {
    let activity: PackActivity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Pack name
            HStack(spacing: 8) {
                Circle()
                    .fill(activity.tintColor.opacity(0.2))
                    .frame(width: 8, height: 8)
                
                Text(activity.packName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.primary)
                    .tracking(0.5)
                
                Spacer()
                
                Text("2m ago")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            // Activity
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(activity.userName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(activity.action)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.primary)
                }
                
                // Consequence
                HStack(spacing: 8) {
                    Image(systemName: activity.status == .failed ? "lock.fill" : "checkmark.circle.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(activity.tintColor)
                    
                    Text(activity.consequence)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(activity.tintColor)
                }
            }
            
            // Members
            HStack(spacing: 8) {
                Image(systemName: "person.3.fill")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(activity.members)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(in: .rect(cornerRadius: 20))
    }
}

#Preview {
    OnboardingStep7View(onContinue: {})
}
