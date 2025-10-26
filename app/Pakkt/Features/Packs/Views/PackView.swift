import SwiftUI

struct PackView: View {
    // Mock data for leaderboard
    let leaderboardMembers: [LeaderboardMember] = [
        LeaderboardMember(id: UUID(), name: "You", initials: "ME", streak: 14, checkIns: 152, fines: 3, jailTime: 45, isCurrentUser: true),
        LeaderboardMember(id: UUID(), name: "Sarah Kim", initials: "SK", streak: 12, checkIns: 148, fines: 2, jailTime: 30, isCurrentUser: false),
        LeaderboardMember(id: UUID(), name: "Mike Johnson", initials: "MJ", streak: 10, checkIns: 142, fines: 5, jailTime: 60, isCurrentUser: false),
        LeaderboardMember(id: UUID(), name: "Alex Chen", initials: "AC", streak: 8, checkIns: 135, fines: 1, jailTime: 15, isCurrentUser: false),
        LeaderboardMember(id: UUID(), name: "Emma Davis", initials: "ED", streak: 5, checkIns: 120, fines: 4, jailTime: 90, isCurrentUser: false)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Leaderboard Section (FIRST - most important)
                    Section {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("LEADERBOARD")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                NavigationLink(destination: PackLeaderboardsView()) {
                                    HStack {
                                        Text("See All")
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                    }
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blue)
                                }
                            }
                            
                            // Show only top 3 - using direct indexing to avoid type inference issues
                            ForEach(0..<min(3, leaderboardMembers.count), id: \.self) { index in
                                let member = getSortedMembers()[index]
                                LeaderboardRow(member: member, rank: index + 1)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 16)
                    
                    // Pack Members Grid Section (SECOND)
                    Section {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("PACK MEMBERS")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Image(systemName: "person.crop.circle.badge.plus")
                                        .font(.title3)
                                }
                            }
                            
                            // Members Grid
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                                ForEach(mockPackMembers) { member in
                                    MemberCard(member: member)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Pack Settings Section (THIRD)
                    Section {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("PACK SETTINGS")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            // Settings options
                            VStack(spacing: 12) {
                                SettingItem(icon: "person.2.fill", title: "Manage Members", action: {})
                                SettingItem(icon: "gearshape.fill", title: "Pack Rules", action: {})
                                SettingItem(icon: "bell.fill", title: "Notification Settings", action: {})
                                SettingItem(icon: "archivebox.fill", title: "Pack History", action: {})
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    Spacer().frame(height: 80)
                }
            }
            .navigationTitle("My Pack")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func getSortedMembers() -> [LeaderboardMember] {
        return leaderboardMembers.sorted { $0.streak > $1.streak }
    }
}

// MARK: - Member Card Component
struct MemberCard: View {
    let member: PackMemberItem
    
    var body: some View {
        VStack(spacing: 8) {
            // Avatar
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color(hex: member.color), Color(hex: member.darkColor)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 60, height: 60)
                
                Text(member.initials)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Name and status
            VStack(spacing: 2) {
                Text(member.name)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("\(member.streak) day streak")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Setting Item Component
struct SettingItem: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .glassEffect(in: .rect(cornerRadius: 12))
        }
    }
}

// MARK: - Supporting Types
struct PackMemberItem: Identifiable {
    let id = UUID()
    let name: String
    let initials: String
    let streak: Int
    let color: String
    let darkColor: String
    let isCurrentUser: Bool
}

// Mock data
let mockPackMembers: [PackMemberItem] = [
    PackMemberItem(name: "You", initials: "ME", streak: 14, color: "#007AFF", darkColor: "#5856D6", isCurrentUser: true),
    PackMemberItem(name: "Sarah Kim", initials: "SK", streak: 12, color: "#FF2D55", darkColor: "#5856D6", isCurrentUser: false),
    PackMemberItem(name: "Mike Johnson", initials: "MJ", streak: 10, color: "#34C759", darkColor: "#AF52DE", isCurrentUser: false),
    PackMemberItem(name: "Alex Chen", initials: "AC", streak: 8, color: "#FF9500", darkColor: "#FF2D55", isCurrentUser: false),
    PackMemberItem(name: "Emma Davis", initials: "ED", streak: 5, color: "#AF52DE", darkColor: "#34C759", isCurrentUser: false),
    PackMemberItem(name: "James Wilson", initials: "JW", streak: 3, color: "#5856D6", darkColor: "#FF9500", isCurrentUser: false)
]

// MARK: - Leaderboard Row Component
struct LeaderboardRow: View {
    let member: LeaderboardMember
    let rank: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // Rank and Avatar
            HStack(spacing: 6) {
                // Rank indicator (with special styling for top 3)
                Text("\(rank)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(getRankColor())
                    .frame(width: 24)
                
                // Trophy for top 3
                if rank <= 3 {
                    Image(systemName: getRankTrophy())
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(getRankColor())
                }
                
                // User Avatar
                ZStack {
                    Circle()
                        .fill(getRankGradient())
                        .frame(width: 36, height: 36)
                    
                    Text(member.initials)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            // User Info
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(member.name)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primary)
                    
                    if member.isCurrentUser {
                        Text("YOU")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue)
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    // Streak value
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "#FF4500"))
                        
                        Text("\(member.streak)d")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding(12)
        .glassEffect(in: .rect(cornerRadius: 16))
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
}

#Preview {
    PackView()
}