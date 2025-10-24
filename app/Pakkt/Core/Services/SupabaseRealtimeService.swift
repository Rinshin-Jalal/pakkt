import Foundation
import Supabase

@available(iOS 16.0, *)
actor SupabaseRealtimeService {
    private let supabase: SupabaseClient
    private var channels: [String: RealtimeChannelV2] = [:]

    init(supabaseURL: URL, supabaseAnonKey: String) {
        self.supabase = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseAnonKey
        )
    }

    convenience init() {
        guard let url = URL(string: APIConfiguration.supabaseURL) else {
            fatalError("Invalid Supabase URL in APIConfiguration")
        }
        self.init(supabaseURL: url, supabaseAnonKey: APIConfiguration.supabaseAnonKey)
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
            if let checkIn = try? JSONDecoder().decode(CheckIn.self, from: JSONEncoder().encode(insert.record)) {
                onInsert(checkIn)
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Fine Votes Subscription (Phase 6)
    // NOTE: FineVote model will be implemented in Phase 6
    // This method signature is ready, implementation will be completed when model exists

    func subscribeToFineVotes(
        fineId: String,
        onInsert: @escaping (Any) -> Void
    ) async throws {
        let channelId = "fine_votes:\(fineId)"

        let channel = await supabase.realtimeV2.channel(channelId)

        let insertChange = await channel.onPostgresChange(
            InsertAction.self,
            schema: "public",
            table: "fine_votes",
            filter: "fine_id=eq.\(fineId)"
        ) { insert in
            // TODO: Replace 'Any' with FineVote when model is implemented in Phase 6
            // if let vote = try? JSONDecoder().decode(FineVote.self, from: JSONEncoder().encode(insert.record)) {
            //     onInsert(vote)
            // }
            onInsert(insert.record)
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Comments Subscription (Phase 5)
    // NOTE: Comment model will be implemented in Phase 5
    // This method signature is ready, implementation will be completed when model exists

    func subscribeToComments(
        checkInId: String,
        onInsert: @escaping (Any) -> Void
    ) async throws {
        let channelId = "comments:\(checkInId)"

        let channel = await supabase.realtimeV2.channel(channelId)

        let insertChange = await channel.onPostgresChange(
            InsertAction.self,
            schema: "public",
            table: "comments",
            filter: "check_in_id=eq.\(checkInId)"
        ) { insert in
            // TODO: Replace 'Any' with Comment when model is implemented in Phase 5
            // if let comment = try? JSONDecoder().decode(Comment.self, from: JSONEncoder().encode(insert.record)) {
            //     onInsert(comment)
            // }
            onInsert(insert.record)
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Reactions Subscription (Phase 5)
    // NOTE: Reaction model will be implemented in Phase 5
    // This method signature is ready, implementation will be completed when model exists

    func subscribeToReactions(
        checkInId: String,
        onInsert: @escaping (Any) -> Void
    ) async throws {
        let channelId = "reactions:\(checkInId)"

        let channel = await supabase.realtimeV2.channel(channelId)

        let insertChange = await channel.onPostgresChange(
            InsertAction.self,
            schema: "public",
            table: "reactions",
            filter: "check_in_id=eq.\(checkInId)"
        ) { insert in
            // TODO: Replace 'Any' with Reaction when model is implemented in Phase 5
            // if let reaction = try? JSONDecoder().decode(Reaction.self, from: JSONEncoder().encode(insert.record)) {
            //     onInsert(reaction)
            // }
            onInsert(insert.record)
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
}
