import SwiftUI

struct OnboardingStep29View: View {
    let onContinue: () -> Void
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text("THIS IS YOUR PACK'S REALITY")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("Who showed up? Who's paying?")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                .padding(.horizontal, 24)
                
                // Feed preview
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Today section
                        DateDivider(text: "Today")
                        
                        // Sample feed items
                        FeedItemPreview(
                            name: "Alex",
                            action: "checked in on time",
                            time: "2m ago",
                            isSuccess: true,
                            isCurrentUser: false
                        )
                        
                        FeedItemPreview(
                            name: "Jordan",
                            action: "missed check-in",
                            time: "5m ago",
                            isSuccess: false,
                            isCurrentUser: false
                        )
                        
                        FeedItemPreview(
                            name: "You",
                            action: "checked in on time",
                            time: "12m ago",
                            isSuccess: true,
                            isCurrentUser: true
                        )
                        
                        Spacer().frame(height: 10)
                        
                        // Yesterday section
                        DateDivider(text: "Yesterday")
                        
                        FeedItemPreview(
                            name: "Taylor",
                            action: "missed check-in - 1hr jail",
                            time: "Yesterday",
                            isSuccess: false,
                            isCurrentUser: false
                        )
                        
                        FeedItemPreview(
                            name: "Sam",
                            action: "checked in on time",
                            time: "Yesterday",
                            isSuccess: true,
                            isCurrentUser: false
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
                
                Spacer()
                
                // Continue button
                Button(action: onContinue) {
                    Text("See What Happens When You Skip")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

struct FeedItemPreview: View {
    let name: String
    let action: String
    let time: String
    let isSuccess: Bool
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if isCurrentUser {
                Spacer()
            }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 8) {
                // Name and time
                HStack(spacing: 8) {
                    if !isCurrentUser {
                        Text(name)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                    
                    Text(time)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    
                    if isCurrentUser {
                        Text(name)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                }
                
                // Action card
                HStack(spacing: 12) {
                    Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(isSuccess ? .green : .red)
                    
                    Text(action)
                        .font(.system(size: 15))
                        .foregroundStyle(.primary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassEffect(in: .rect(cornerRadius: 16))
            }
            .frame(maxWidth: 280)
            
            if !isCurrentUser {
                Spacer()
            }
        }
    }
}

#Preview {
    OnboardingStep29View(onContinue: {})
}
