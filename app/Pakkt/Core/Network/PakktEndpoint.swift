import Foundation

enum PakktEndpoint: Endpoint {
    // Users
    case getProfile
    case updateProfile(UpdateProfileRequest)
    case registerPushToken(PushTokenRequest)
    case deletePushToken
    
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

    var path: String {
        switch self {
        case .getProfile, .updateProfile:
            return "/api/users/profile"
        case .registerPushToken:
            return "/api/users/push-token"
        case .deletePushToken:
            return "/api/users/push-token"
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
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getProfile, .getPacks, .getPack, .getTasks, .getFeed, .getPost:
            return .get
        case .registerPushToken, .createPack, .createTask:
            return .post
        case .updateProfile, .updatePack, .updateTask:
            return .patch
        case .deletePushToken, .deletePack, .deleteTask:
            return .delete
        }
    }

    var body: Data? {
        switch self {
        case .updateProfile(let request):
            return try? JSONEncoder().encode(request)
        case .registerPushToken(let request):
            return try? JSONEncoder().encode(request)
        case .createPack(let data), .updatePack(_, let data),
             .createTask(_, let data), .updateTask(_, let data):
            return data
        default:
            return nil
        }
    }

    var headers: [String: String]? {
        return APIConfiguration.defaultHeaders
    }
}
