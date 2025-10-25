// app/Pakkt/Core/Navigation/DeepLinkHandler.swift
import Foundation

enum DeepLink: Equatable {
    case pack(id: UUID)
    case goal(id: UUID)
    case checkIn(id: UUID)
    case fine(id: UUID)
    case jailSession(id: UUID)
    case comment(checkInId: UUID)
    case reaction(checkInId: UUID)
    case feed
    case profile
}

actor DeepLinkHandler {
    func handle(_ url: URL) -> DeepLink? {
        guard url.scheme == "pakkt" else { return nil }

        let path = url.path
        let components = path.split(separator: "/").map(String.init)

        guard components.count >= 2 else { return nil }

        let type = components[0]
        let id = components[1]

        guard let uuid = UUID(uuidString: id) else {
            // Handle non-UUID paths
            switch type {
            case "feed":
                return .feed
            case "profile":
                return .profile
            default:
                return nil
            }
        }

        switch type {
        case "pack":
            return .pack(id: uuid)
        case "goal":
            return .goal(id: uuid)
        case "checkin":
            return .checkIn(id: uuid)
        case "fine":
            return .fine(id: uuid)
        case "jail":
            return .jailSession(id: uuid)
        default:
            return nil
        }
    }

    func handle(userInfo: [AnyHashable: Any]) -> DeepLink? {
        // Handle push notification payload
        // APNs sends custom data inside the root level of userInfo
        // Our backend sends: data: { type: 'check_in', id: '...', ... }

        // Try to extract from root level first (for backwards compatibility)
        var type: String? = userInfo["type"] as? String
        var idString: String? = userInfo["id"] as? String

        // If not found, try the 'data' object (APNs format)
        if type == nil || idString == nil {
            if let data = userInfo["data"] as? [String: Any] {
                type = data["type"] as? String
                idString = data["id"] as? String
            }
        }

        guard let type = type, let idString = idString else {
            return nil
        }

        // Handle non-UUID types
        if type == "feed" {
            return .feed
        }

        if type == "profile" {
            return .profile
        }

        guard let id = UUID(uuidString: idString) else { return nil }

        // Map backend notification types (with underscores) to iOS deep links
        switch type {
        case "pack":
            return .pack(id: id)
        case "goal":
            return .goal(id: id)
        case "check_in", "checkin":  // Handle both formats
            return .checkIn(id: id)
        case "fine":
            return .fine(id: id)
        case "jail", "jail_session":  // Handle both formats
            return .jailSession(id: id)
        case "comment":
            // For comments, navigate to the check-in that was commented on
            return .comment(checkInId: id)
        case "reaction":
            // For reactions, navigate to the check-in that was reacted to
            return .reaction(checkInId: id)
        default:
            return nil
        }
    }
}