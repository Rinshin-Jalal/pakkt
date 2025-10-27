import SwiftUI

// MARK: - Step 7: Real Pack Examples
struct OnboardingStep7View: View {
    @State private var showContent = false
    @State private var currentIndex = 0
    let onContinue: () -> Void
    
    let examples: [PackActivity] = [
        PackActivity(
            packName: "Iron Wolves",
            userName: "Jake",
            action: "missed leg day",
            consequence: "1hr jail",
            status: .failed,
            members: "3/4 checked in",
            comments: ["Dude, again?! - Mike", "Better show up tomorrow - Sarah"],
            tintColor: Color(hex: "#FF3B30")
        ),
        PackActivity(
            packName: "Brain Trust",
            userName: "Sarah",
            action: "crushed chem study",
            consequence: "15-day streak",
            status: .success,
            members: "5/5 studied tonight",
            comments: ["Queen! - Mike", "Let's go! - Tom"],
            tintColor: Color(hex: "#0066FF")
        ),
        PackActivity(
            packName: "Sober Squad",
            userName: "Mike",
            action: "survived Tuesday sober",
            consequence: "Pack proud",
            status: .success,
            members: "4/4 stayed sober",
            comments: ["Legend! - Jake", "Wednesday too? - Sarah"],
            tintColor: Color(hex: "#00D448")
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("LIVE PACK FEEDS")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("47,823 packs active right now")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .opacity(showContent ? 1 : 0)
                .padding(.top, 60)
                .padding(.bottom, 24)
                
                // Carousel
                TabView(selection: $currentIndex) {
                    ForEach(Array(examples.enumerated()), id: \.offset) { index, activity in
                        PackActivityCarouselCard(activity: activity)
                            .padding(.horizontal, 20)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 450)
                .opacity(showContent ? 1 : 0)
                
                // Page indicator hint
                Text("SWIPE FOR MORE")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(1.0)
                    .opacity(showContent ? 0.6 : 0)
                    .padding(.bottom, 16)
                
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
    let comments: [String]
    let tintColor: Color
    
    enum ActivityStatus {
        case success, failed
    }
}

// MARK: - Pack Activity Carousel Card
struct PackActivityCarouselCard: View {
    let activity: PackActivity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Pack name header
            HStack(spacing: 8) {
                Circle()
                    .fill(activity.tintColor.opacity(0.2))
                    .frame(width: 10, height: 10)
                
                Text(activity.packName.uppercased())
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .tracking(1.0)
                
                Spacer()
                
                Text("2m ago")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Activity content
            VStack(alignment: .leading, spacing: 16) {
                // User action
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.userName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(activity.action)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                // Consequence
                HStack(spacing: 10) {
                    Image(systemName: activity.status == .failed ? "lock.fill" : "checkmark.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(activity.tintColor)
                    
                    Text(activity.consequence)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(activity.tintColor)
                }
                .padding(.vertical, 8)
            }
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Members
            HStack(spacing: 8) {
                Image(systemName: "person.3.fill")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(activity.members)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            // Comments
            VStack(alignment: .leading, spacing: 10) {
                ForEach(activity.comments, id: \.self) { comment in
                    HStack(spacing: 8) {
                        Image(systemName: "bubble.left.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(activity.tintColor.opacity(0.6))
                        
                        Text(comment)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .glassEffect(in: .rect(cornerRadius: 24))
    }
}

#Preview {
    OnboardingStep7View(onContinue: {})
}
