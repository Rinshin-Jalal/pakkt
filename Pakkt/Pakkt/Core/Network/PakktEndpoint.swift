import Foundation

enum PakktEndpoint: Endpoint {
    // Packs
    case getPacks
    case createPack(data: Data)
    case getPack(id: String)
    case updatePack(id: String, data: Data)
    case deletePack(id: String)

    // Tasks
    case getTasks(packId: String)
    case createTask(packId: String, data: Data)
    case updateTask(id: String, data: Data)
    case deleteTask(id: String)

    // Feed
    case getFeed
    case getPost(id: String)

    // Profile
    case getProfile(userId: String)
    case updateProfile(data: Data)

    var path: String {
        switch self {
        case .getPacks, .createPack:
            return "/rest/v1/packs"
        case .getPack(let id), .updatePack(let id, _), .deletePack(let id):
            return "/rest/v1/packs?id=eq.\(id)"
        case .getTasks(let packId):
            return "/rest/v1/tasks?pack_id=eq.\(packId)"
        case .createTask:
            return "/rest/v1/tasks"
        case .updateTask(let id, _), .deleteTask(let id):
            return "/rest/v1/tasks?id=eq.\(id)"
        case .getFeed:
            return "/rest/v1/feed"
        case .getPost(let id):
            return "/rest/v1/posts?id=eq.\(id)"
        case .getProfile(let userId):
            return "/rest/v1/profiles?user_id=eq.\(userId)"
        case .updateProfile:
            return "/rest/v1/profiles"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPacks, .getPack, .getTasks, .getFeed, .getPost, .getProfile:
            return .get
        case .createPack, .createTask:
            return .post
        case .updatePack, .updateTask, .updateProfile:
            return .patch
        case .deletePack, .deleteTask:
            return .delete
        }
    }

    var body: Data? {
        switch self {
        case .createPack(let data), .updatePack(_, let data),
             .createTask(_, let data), .updateTask(_, let data),
             .updateProfile(let data):
            return data
        default:
            return nil
        }
    }

    var headers: [String: String]? {
        return APIConfiguration.defaultHeaders
    }
}
