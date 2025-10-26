import Foundation

struct LeaderboardMember: Identifiable {
    let id: UUID
    let name: String
    let initials: String
    let streak: Int
    let checkIns: Int
    let fines: Int
    let jailTime: Int
    let isCurrentUser: Bool
}

enum LeaderboardMetric: CaseIterable {
    case streak
    case checkIns
    case fines
    case jailTime
    
    var title: String {
        switch self {
        case .streak: return "Streak"
        case .checkIns: return "Check-ins"
        case .fines: return "Fines"
        case .jailTime: return "Jail Time"
        }
    }
}