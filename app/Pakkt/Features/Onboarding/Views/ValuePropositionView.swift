import SwiftUI

// MARK: - Step 14: Value Proposition (Bridge)
struct ValuePropositionView: View {
    let onContinue: () -> Void
    @State private var currentPage = 0
    @State private var showContent = false
    
    let sections = [
        ValueSection(
            icon: "xmark.circle.fill",
            title: "SOLO ATTEMPTS",
            color: .red,
            items: [
                "Motivation faded",
                "Excuses won",
                "Nobody noticed",
                "You gave up"
            ],
            type: .failure
        ),
        ValueSection(
            icon: "iphone.gen3",
            title: "TRACKING APPS",
            color: .orange,
            items: [
                "No real stakes",
                "Easy to ignore",
                "Just data",
                "Nobody cares"
            ],
            type: .failure
        ),
        ValueSection(
            icon: "checkmark.circle.fill",
            title: "PAKKT WORKS",
            color: .green,
            items: [
                "Real people watching",
                "Actual consequences",
                "Can't ignore it",
                "Your crew enforces"
            ],
            type: .success
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                    .frame(height: 40)
                
                // Header
                VStack(spacing: 8) {
                    Text("YOU TRIED ALONE.")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("IT DIDN'T WORK.")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                
                // Carousel
                TabView(selection: $currentPage) {
                    ForEach(0..<sections.count, id: \.self) { index in
                        ValueSectionCardView(section: sections[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 350)
                .opacity(showContent ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: showContent)
                
                // Transition
                Text("Ready to build your pack?")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Continue Button
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("LET'S BUILD IT")
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
            showContent = true
        }
    }
}

// MARK: - Supporting Types
struct ValueSection {
    let icon: String
    let title: String
    let color: Color
    let items: [String]
    let type: SectionType
    
    enum SectionType {
        case failure, success
    }
}

// MARK: - Card View
struct ValueSectionCardView: View {
    let section: ValueSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: section.icon)
                    .font(.system(size: 32))
                    .foregroundColor(section.color)
                
                Text(section.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                    .tracking(1.0)
            }
            
            // Items List
            VStack(alignment: .leading, spacing: 12) {
                ForEach(section.items, id: \.self) { item in
                    HStack(spacing: 10) {
                        Image(systemName: section.type == .success ? "checkmark" : "circle.fill")
                            .font(.system(size: section.type == .success ? 12 : 6))
                            .foregroundColor(section.type == .success ? section.color : .secondary)
                        
                        Text(item)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 300)
        .glassEffect(in: .rect(cornerRadius: 30))
        .padding(.horizontal, 24)
    }
}

#Preview {
    ValuePropositionView(onContinue: {})
}
