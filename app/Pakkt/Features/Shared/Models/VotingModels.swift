import SwiftUI

// MARK: - Vote Option

enum VoteOption {
    case dontFine
    case fine
    case wait
}

// MARK: - Voting Member

struct VotingMember: Identifiable {
    let id = UUID()
    let name: String
    let initials: String
    let vote: VoteOption?
}

// MARK: - Voting State

enum VotingState {
    case active
    case completed
}

// MARK: - Verdict

enum Verdict {
    case guilty
    case innocent
}

// MARK: - Final Votes

struct FinalVotes {
    let forgive: Int
    let jail: Int
    let wait: Int
}
