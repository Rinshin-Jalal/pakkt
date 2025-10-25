import Foundation
import Supabase
import Combine

@available(iOS 16.0, *)
actor SupabaseRealtimeService {
    private let supabase: Supabase.SupabaseClient
    private var channels: [String: RealtimeChannel] = [:]

    init(supabaseURL: URL, supabaseAnonKey: String) {
        self.supabase = Supabase.SupabaseClient(
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
        onInsert: @escaping ([String: Any]) -> Void
    ) async throws {
        let channelId = "check_ins:\(packId)"

        let channel = supabase.realtime.channel(channelId)

        // Subscribe to INSERT operations on check_ins table
        channel.on(
            .postgresChange(event: .insert, schema: "public", table: "check_ins", filter: "pack_id=eq.\(packId)")
        ) { message in
            if let record = message.payload["record"] as? [String: Any] {
                onInsert(record)
            }
        }

        // Subscribe to UPDATE operations on check_ins table for status changes
        channel.on(
            .postgresChange(event: .update, schema: "public", table: "check_ins", filter: "pack_id=eq.\(packId)")
        ) { message in
            if let record = message.payload["record"] as? [String: Any] {
                onInsert(record)
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Fine Votes Subscription
    func subscribeToFineVotes(
        fineId: String,
        onInsert: @escaping ([String: Any]) -> Void
    ) async throws {
        let channelId = "fine_votes:\(fineId)"

        let channel = supabase.realtime.channel(channelId)

        channel.on(
            .postgresChange(event: .insert, schema: "public", table: "fine_votes", filter: "fine_id=eq.\(fineId)")
        ) { message in
            if let record = message.payload["record"] as? [String: Any] {
                onInsert(record)
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Comments Subscription
    func subscribeToComments(
        checkInId: String,
        onInsert: @escaping ([String: Any]) -> Void
    ) async throws {
        let channelId = "comments:\(checkInId)"

        let channel = supabase.realtime.channel(channelId)

        channel.on(
            .postgresChange(event: .insert, schema: "public", table: "comments", filter: "check_in_id=eq.\(checkInId)")
        ) { message in
            if let record = message.payload["record"] as? [String: Any] {
                onInsert(record)
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Reactions Subscription
    func subscribeToReactions(
        checkInId: String,
        onInsert: @escaping ([String: Any]) -> Void
    ) async throws {
        let channelId = "reactions:\(checkInId)"

        let channel = supabase.realtime.channel(channelId)

        channel.on(
            .postgresChange(event: .insert, schema: "public", table: "reactions", filter: "check_in_id=eq.\(checkInId)")
        ) { message in
            if let record = message.payload["record"] as? [String: Any] {
                onInsert(record)
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Pack Feed Subscription (to update when teammates submit check-ins)
    func subscribeToPackFeed(
        packId: String,
        onInsert: @escaping ([String: Any]) -> Void
    ) async throws {
        let channelId = "pack_feed:\(packId)"

        let channel = supabase.realtime.channel(channelId)

        // Subscribe to INSERT events on check_ins table for the pack
        channel.on(
            .postgresChange(event: .insert, schema: "public", table: "check_ins", filter: "pack_id=eq.\(packId)")
        ) { message in
            if let record = message.payload["record"] as? [String: Any] {
                onInsert(record)
            }
        }

        // Subscribe to updates on existing check-ins (status changes, etc.)
        channel.on(
            .postgresChange(event: .update, schema: "public", table: "check_ins", filter: "pack_id=eq.\(packId)")
        ) { message in
            if let record = message.payload["record"] as? [String: Any] {
                onInsert(record)
            }
        }

        // Also subscribe to related tables that affect the feed
        channel.on(
            .postgresChange(event: .insert, schema: "public", table: "comments", filter: "check_in_id=cs.@check_ins.pack_id=eq.\(packId)")
        ) { message in
            if let record = message.payload["record"] as? [String: Any] {
                onInsert(record)
            }
        }

        channel.on(
            .postgresChange(event: .insert, schema: "public", table: "reactions", filter: "check_in_id=cs.@check_ins.pack_id=eq.\(packId)")
        ) { message in
            if let record = message.payload["record"] as? [String: Any] {
                onInsert(record)
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - App Lifecycle Management

    func handleAppDidEnterBackground() async {
        // Store the channels that were subscribed so we can reconnect when app becomes active
        print("App entered background, storing subscriptions...")
    }

    func handleAppWillEnterForeground() async {
        // Reconnect to channels if they were disconnected during background
        print("App will enter foreground, checking subscriptions...")
        // Channels should automatically reconnect when possible
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
