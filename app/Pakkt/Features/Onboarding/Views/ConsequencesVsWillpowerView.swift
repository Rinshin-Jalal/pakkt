import SwiftUI

// MARK: - Step 10: Consequences vs Willpower (Relief - Breathing Step)
struct ConsequencesVsWillpowerView: View {
    let onContinue: () -> Void
    @State private var currentPage = 0
    @State private var showContent = false
    
    let approaches = [
        ComparisonCard(
            title: "WILLPOWER",
            items: [
                ComparisonItem(icon: "person.fill", text: "Alone"),
                ComparisonItem(icon: "clock.badge.xmark", text: "Fails in 2hrs"),
                ComparisonItem(icon: "xmark.circle.fill", text: "95% quit")
            ],
            type: .negative
        ),
        ComparisonCard(
            title: "CONSEQUENCES",
            items: [
                ComparisonItem(icon: "person.3.fill", text: "Crew"),
                ComparisonItem(icon: "clock.badge.checkmark", text: "Works 24/7"),
                ComparisonItem(icon: "checkmark.circle.fill", text: "Real results")
            ],
            type: .positive
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 40)
                
                // Header
                VStack(spacing: 8) {
                    Text("WILLPOWER FAILS.")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("CONSEQUENCES WIN.")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                
                // Carousel
                TabView(selection: $currentPage) {
                    ForEach(0..<approaches.count, id: \.self) { index in
                        ComparisonCardView(card: approaches[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 400)
                .opacity(showContent ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: showContent)
                
                // Key Insight
                VStack(spacing: 12) {
                    Text("Your brain avoids pain.")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("That's why you need")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text("EXTERNAL consequences")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("you can't ignore.")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.primary)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                
                Spacer()
                    .frame(height: 20)
                
                // Continue Button
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("SHOW ME HOW THIS WORKS")
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
        }
        .onAppear {
            showContent = true
        }
    }
}

// MARK: - Supporting Types
struct ComparisonCard {
    let title: String
    let items: [ComparisonItem]
    let type: ComparisonType
}

struct ComparisonItem {
    let icon: String
    let text: String
}

enum ComparisonType {
    case negative, positive
}

// MARK: - Card View
struct ComparisonCardView: View {
    let card: ComparisonCard
    
    var body: some View {
        VStack(spacing: 24) {
            // Title
            Text(card.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .tracking(1.5)
            
            // Items
            VStack(spacing: 20) {
                ForEach(card.items.indices, id: \.self) { index in
                    VStack(spacing: 8) {
                        Image(systemName: card.items[index].icon)
                            .font(.system(size: 32))
                            .foregroundColor(iconColor(for: card.type, index: index))
                        
                        Text(card.items[index].text)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glassEffect(in: .rect(cornerRadius: 30))
        .padding(.horizontal, 24)
    }
    
    private func iconColor(for type: ComparisonType, index: Int) -> Color {
        switch type {
        case .negative:
            return index == card.items.count - 1 ? .red : .secondary
        case .positive:
            return index == card.items.count - 1 ? .green : .blue
        }
    }
}

#Preview {
    ConsequencesVsWillpowerView(onContinue: {})
}
