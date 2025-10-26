import SwiftUI

struct PackLeaderboardsView: View {
    @State private var selectedMetric = LeaderboardMetric.streak
    
    // Mock data for pack members
    let packMembers: [LeaderboardMember] = [
        LeaderboardMember(id: UUID(), name: "You", initials: "ME", streak: 14, checkIns: 152, fines: 3, jailTime: 45, isCurrentUser: true),
        LeaderboardMember(id: UUID(), name: "Sarah Kim", initials: "SK", streak: 12, checkIns: 148, fines: 2, jailTime: 30, isCurrentUser: false),
        LeaderboardMember(id: UUID(), name: "Mike Johnson", initials: "MJ", streak: 10, checkIns: 142, fines: 5, jailTime: 60, isCurrentUser: false),
        LeaderboardMember(id: UUID(), name: "Alex Chen", initials: "AC", streak: 8, checkIns: 135, fines: 1, jailTime: 15, isCurrentUser: false),
        LeaderboardMember(id: UUID(), name: "Emma Davis", initials: "ED", streak: 5, checkIns: 120, fines: 4, jailTime: 90, isCurrentUser: false)
    ]
    
    var body: some View {
        ZStack {
            // Background with native dark mode support
            Color(.systemBackground)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
            
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Metric Selection
                    HStack {
                        ForEach(LeaderboardMetric.allCases, id: \.self) { metric in
                            Button(action: {
                                selectedMetric = metric
                            }) {
                                Text(metric.title)
                                    .font(.system(size: 14, weight: selectedMetric == metric ? .bold : .regular))
                                    .foregroundColor(selectedMetric == metric ? .primary : .secondary)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(
                                        selectedMetric == metric 
                                            ? Color.primary.opacity(0.1)
                                            : Color.clear
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    // Leaderboard Cards
                    ForEach(getRankedMembers()) { member in
                        LeaderboardCard(member: member, rank: getRankForMember(member), selectedMetric: selectedMetric)
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer().frame(height: 80)
                }
            }
            .navigationTitle("Leaderboard")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func getRankedMembers() -> [LeaderboardMember] {
        let sortedMembers: [LeaderboardMember]
        
        switch selectedMetric {
        case .streak:
            sortedMembers = packMembers.sorted { $0.streak > $1.streak }
        case .checkIns:
            sortedMembers = packMembers.sorted { $0.checkIns > $1.checkIns }
        case .fines:
            sortedMembers = packMembers.sorted { $0.fines < $1.fines } // Lower fines is better
        case .jailTime:
            sortedMembers = packMembers.sorted { $0.jailTime < $1.jailTime } // Lower jail time is better
        }
        
        return sortedMembers
    }
    
    private func getRankForMember(_ member: LeaderboardMember) -> Int {
        let rankedMembers = getRankedMembers()
        return rankedMembers.firstIndex(where: { $0.id == member.id }) ?? 0 + 1
    }
}

// MARK: - Leaderboard Card Component
struct LeaderboardCard: View {
    let member: LeaderboardMember
    let rank: Int
    let selectedMetric: LeaderboardMetric
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank and Avatar
            HStack(spacing: 8) {
                // Rank indicator (with special styling for top 3)
                Text("\(rank)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(getRankColor())
                    .frame(width: 20)
                
                // Trophy for top 3
                if rank <= 3 {
                    Image(systemName: getRankTrophy())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(getRankColor())
                }
                
                // User Avatar
                VStack(spacing: 4) {
                    Circle()
                        .fill(getRankGradient())
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text(member.initials)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    if member.isCurrentUser {
                        Text("YOU")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.primary)
                    }
                }
            }
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(member.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Value based on selected metric
                    Text(getMetricValue())
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                // Current streak or other metric description
                Text(getMetricDescription())
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            // Arrow for detail view (if needed)
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.secondary)
                .opacity(0.5)
        }
        .padding(16)
        .glassEffect(in: .rect(cornerRadius: 20))
    }
    
    private func getRankColor() -> Color {
        switch rank {
        case 1:
            return Color(hex: "#FFD700") // Gold
        case 2:
            return Color(hex: "#C0C0C0") // Silver
        case 3:
            return Color(hex: "#CD7F32") // Bronze
        default:
            return Color.primary
        }
    }
    
    private func getRankGradient() -> LinearGradient {
        switch rank {
        case 1:
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#FFD700"), Color(hex: "#FFA500")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 2:
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#C0C0C0"), Color(hex: "#A0A0A0")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 3:
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#CD7F32"), Color(hex: "#A0522D")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#007AFF"), Color(hex: "#5856D6")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private func getRankTrophy() -> String {
        switch rank {
        case 1: return "trophy.fill"
        case 2: return "trophy"
        case 3: return "tag.fill"
        default: return "person.fill"
        }
    }
    
    private func getMetricValue() -> String {
        switch selectedMetric {
        case .streak:
            return "\(member.streak)d"
        case .checkIns:
            return "\(member.checkIns)"
        case .fines:
            return "\(member.fines)"
        case .jailTime:
            return "\(member.jailTime)m"
        }
    }
    
    private func getMetricDescription() -> String {
        switch selectedMetric {
        case .streak:
            return "Day streak"
        case .checkIns:
            return "Total check-ins"
        case .fines:
            return "Fines paid"
        case .jailTime:
            return "Jail time (min)"
        }
    }
}

// MARK: - Supporting Types

#Preview {
    NavigationStack {
        PackLeaderboardsView()
    }
}