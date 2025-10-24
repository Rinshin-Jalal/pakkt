// app/Pakkt/Core/Navigation/DeepLinkHandler.swift
import Foundation

enum DeepLink: Equatable {
    case pack(id: UUID)
    case goal(id: UUID)
    case checkIn(id: UUID)
    case fine(id: UUID)
    case jailSession(id: UUID)
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
        guard let type = userInfo["type"] as? String,
              let idString = userInfo["id"] as? String else {
            return nil
        }

        if type == "feed" {
            return .feed
        }

        if type == "profile" {
            return .profile
        }

        guard let id = UUID(uuidString: idString) else { return nil }

        switch type {
        case "pack":
            return .pack(id: id)
        case "goal":
            return .goal(id: id)
        case "checkin":
            return .checkIn(id: id)
        case "fine":
            return .fine(id: id)
        case "jail":
            return .jailSession(id: id)
        default:
            return nil
        }
    }
}