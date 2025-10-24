import Foundation
import Supabase
import Combine

actor SupabaseRealtimeService {
    private let supabase: SupabaseClient
    private var channels: [String: RealtimeChannelV2] = [:]

    init(supabaseURL: URL, supabaseAnonKey: String) {
        self.supabase = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseAnonKey
        )
    }

    // Convenience initializer using APIConfiguration
    init() {
        guard let url = URL(string: APIConfiguration.supabaseURL) else {
            fatalError("Invalid Supabase URL in APIConfiguration")
        }
        self.supabase = SupabaseClient(
            supabaseURL: url,
            supabaseKey: APIConfiguration.supabaseAnonKey
        )
    }

    // MARK: - Check-ins Subscription

    func subscribeToCheckIns(
        packId: String,
        onInsert: @escaping (CheckIn) -> Void
    ) async throws {
        let channelId = "check_ins:\(packId)"

        let channel = await supabase.realtimeV2.channel(channelId)

        let insertChange = await channel.onPostgresChange(
            InsertAction.self,
            schema: "public",
            table: "check_ins",
            filter: "pack_id=eq.\(packId)"
        ) { insert in
            do {
                let jsonData = try JSONEncoder().encode(insert.record)
                let checkIn = try JSONDecoder().decode(CheckIn.self, from: jsonData)
                onInsert(checkIn)
            } catch {
                print("❌ Failed to decode check-in: \(error)")
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Fine Votes Subscription

    func subscribeToFineVotes(
        fineId: String,
        onInsert: @escaping (FineVote) -> Void
    ) async throws {
        let channelId = "fine_votes:\(fineId)"

        let channel = await supabase.realtimeV2.channel(channelId)

        let insertChange = await channel.onPostgresChange(
            InsertAction.self,
            schema: "public",
            table: "fine_votes",
            filter: "fine_id=eq.\(fineId)"
        ) { insert in
            do {
                let jsonData = try JSONEncoder().encode(insert.record)
                let vote = try JSONDecoder().decode(FineVote.self, from: jsonData)
                onInsert(vote)
            } catch {
                print("❌ Failed to decode fine vote: \(error)")
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Comments Subscription

    func subscribeToComments(
        checkInId: String,
        onInsert: @escaping (Comment) -> Void
    ) async throws {
        let channelId = "comments:\(checkInId)"

        let channel = await supabase.realtimeV2.channel(channelId)

        let insertChange = await channel.onPostgresChange(
            InsertAction.self,
            schema: "public",
            table: "comments",
            filter: "check_in_id=eq.\(checkInId)"
        ) { insert in
            do {
                let jsonData = try JSONEncoder().encode(insert.record)
                let comment = try JSONDecoder().decode(Comment.self, from: jsonData)
                onInsert(comment)
            } catch {
                print("❌ Failed to decode comment: \(error)")
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Reactions Subscription

    func subscribeToReactions(
        checkInId: String,
        onInsert: @escaping (Reaction) -> Void
    ) async throws {
        let channelId = "reactions:\(checkInId)"

        let channel = await supabase.realtimeV2.channel(channelId)

        let insertChange = await channel.onPostgresChange(
            InsertAction.self,
            schema: "public",
            table: "reactions",
            filter: "check_in_id=eq.\(checkInId)"
        ) { insert in
            do {
                let jsonData = try JSONEncoder().encode(insert.record)
                let reaction = try JSONDecoder().decode(Reaction.self, from: jsonData)
                onInsert(reaction)
            } catch {
                print("❌ Failed to decode reaction: \(error)")
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Pack Activity Subscription (All Updates)

    func subscribeToPackActivity(
        packId: String,
        onCheckIn: @escaping (CheckIn) -> Void,
        onFine: @escaping (Fine) -> Void
    ) async throws {
        let channelId = "pack_activity:\(packId)"

        let channel = await supabase.realtimeV2.channel(channelId)

        // Listen for check-ins
        let checkInChange = await channel.onPostgresChange(
            InsertAction.self,
            schema: "public",
            table: "check_ins",
            filter: "pack_id=eq.\(packId)"
        ) { insert in
            do {
                let jsonData = try JSONEncoder().encode(insert.record)
                let checkIn = try JSONDecoder().decode(CheckIn.self, from: jsonData)
                onCheckIn(checkIn)
            } catch {
                print("❌ Failed to decode check-in: \(error)")
            }
        }

        // Listen for fines
        let fineChange = await channel.onPostgresChange(
            InsertAction.self,
            schema: "public",
            table: "fines",
            filter: "pack_id=eq.\(packId)"
        ) { insert in
            do {
                let jsonData = try JSONEncoder().encode(insert.record)
                let fine = try JSONDecoder().decode(Fine.self, from: jsonData)
                onFine(fine)
            } catch {
                print("❌ Failed to decode fine: \(error)")
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Unsubscribe

    func unsubscribe(from channelId: String) async {
        if let channel = channels[channelId] {
            await channel.unsubscribe()
            channels.removeValue(forKey: channelId)
        }
    }

    func unsubscribeAll() async {
        for channel in channels.values {
            await channel.unsubscribe()
        }
        channels.removeAll()
    }

    // MARK: - Helper to get channel ID

    func getChannelId(for subscription: RealtimeSubscription) -> String {
        switch subscription {
        case .checkIns(let packId):
            return "check_ins:\(packId)"
        case .fineVotes(let fineId):
            return "fine_votes:\(fineId)"
        case .comments(let checkInId):
            return "comments:\(checkInId)"
        case .reactions(let checkInId):
            return "reactions:\(checkInId)"
        case .packActivity(let packId):
            return "pack_activity:\(packId)"
        }
    }
}

// MARK: - Subscription Types

enum RealtimeSubscription {
    case checkIns(packId: String)
    case fineVotes(fineId: String)
    case comments(checkInId: String)
    case reactions(checkInId: String)
    case packActivity(packId: String)
}

// MARK: - Placeholder Models (will be replaced by actual models in Phase 2+)

// These are temporary placeholders - we'll create the real models in later phases
struct CheckIn: Codable {
    let id: String
    let userId: String
    let packId: String
    let goalId: String
    let proofUrl: String?
    let caption: String?
    let createdAt: String
}

struct FineVote: Codable {
    let id: String
    let fineId: String
    let userId: String
    let vote: Bool
    let createdAt: String
}

struct Comment: Codable {
    let id: String
    let checkInId: String
    let userId: String
    let content: String
    let createdAt: String
}

struct Reaction: Codable {
    let id: String
    let checkInId: String
    let userId: String
    let emoji: String
    let createdAt: String
}

struct Fine: Codable {
    let id: String
    let packId: String
    let userId: String
    let goalId: String
    let amount: Int
    let reason: String
    let status: String
    let createdAt: String
}
