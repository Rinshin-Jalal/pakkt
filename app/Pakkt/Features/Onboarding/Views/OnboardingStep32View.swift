import SwiftUI

struct OnboardingStep32View: View {
    let onContinue: () -> Void
    @State private var currentStory = 0
    
    let successStories = [
        (name: "Sarah's Pack", days: 47, metric: "Days strong", detail: "5 members quit together"),
        (name: "Jake's Crew", days: 89, metric: "Days vape-free", detail: "$2,840 saved"),
        (name: "The Bros", days: 156, metric: "Days sober", detail: "Gym 6x/week now"),
        (name: "Mike's Squad", days: 203, metric: "Days clean", detail: "Lost 45lbs together")
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Text("YOU'VE TRIED ALONE")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundStyle(.primary)
                    
                    Text("Time to try with your crew")
                        .font(.system(size: 17))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 32)
                
                // Value Proposition
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 12) {
                        Text("$4")
                            .font(.system(size: 56, weight: .heavy))
                            .foregroundStyle(.cyan)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("PER WEEK")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(.secondary)
                            Text("= One coffee")
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary.opacity(0.7))
                        }
                    }
                    .padding(.bottom, 8)
                    
                    Text("But instead of caffeine, you get:")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 16)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ValueItem(icon: "person.3.fill", text: "Real accountability from people who care")
                        ValueItem(icon: "shield.fill", text: "Your crew watching your back 24/7")
                        ValueItem(icon: "lock.fill", text: "Instant jail time if you slip (they'll know)")
                        ValueItem(icon: "chart.line.uptrend.xyaxis", text: "A feed where your wins matter")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
            
                
                // Continue Button
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("SEE PRICING")
                            .font(.system(size: 17, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                   
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
        }
    }
}

struct ValueItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(.cyan)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 15))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

struct StoryCard: View {
    let story: (name: String, days: Int, metric: String, detail: String)
    
    var body: some View {
        VStack(spacing: 16) {
            Text(story.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.primary)
            
            VStack(spacing: 8) {
                Text("\(story.days)")
                    .font(.system(size: 48, weight: .heavy))
                    .foregroundStyle(.cyan)
                
                Text(story.metric)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            
            Text(story.detail)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .glassEffect(in: .rect(cornerRadius: 30))
    }
}

#Preview {
    OnboardingStep32View(onContinue: {})
}
