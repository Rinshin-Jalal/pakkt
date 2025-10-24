import Foundation

enum PakktEndpoint: Endpoint {
    // Users
    case getProfile
    case updateProfile(UpdateProfileRequest)
    case registerPushToken(PushTokenRequest)
    case deletePushToken
    
    // Packs
    case listPacks
    case createPack(CreatePackRequest)
    case getPack(id: UUID)
    case updatePack(id: UUID, request: UpdatePackRequest)
    case dissolvePack(id: UUID)
    case getPackMembers(packId: UUID)
    case removePackMember(packId: UUID, userId: UUID)
    case getPackStats(packId: UUID)
    
    // Invite Codes (Self-Join System)
    case createInviteCode(packId: UUID, request: CreateInviteCodeRequest)
    case listInviteCodes(packId: UUID)
    case validateInviteCode(String)
    case useInviteCode(UseInviteCodeRequest)
    case deactivateInviteCode(packId: UUID, codeId: UUID)
    case deleteInviteCode(packId: UUID, codeId: UUID)

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
        case .listPacks, .createPack:
            return "/api/packs"
        case .getPack(let id), .updatePack(let id, _), .dissolvePack(let id):
            return "/api/packs/\(id.uuidString)"
        case .getPackMembers(let packId):
            return "/api/packs/\(packId.uuidString)/members"
        case .removePackMember(let packId, let userId):
            return "/api/packs/\(packId.uuidString)/members/\(userId.uuidString)"
        case .getPackStats(let packId):
            return "/api/packs/\(packId.uuidString)/stats"
        case .createInviteCode(let packId, _), .listInviteCodes(let packId):
            return "/api/packs/\(packId.uuidString)/invite-codes"
        case .validateInviteCode(let code):
            return "/api/invite-codes/\(code)/validate"
        case .useInviteCode:
            return "/api/invite-codes/use"
        case .deactivateInviteCode(let packId, let codeId):
            return "/api/packs/\(packId.uuidString)/invite-codes/\(codeId.uuidString)/deactivate"
        case .deleteInviteCode(let packId, let codeId):
            return "/api/packs/\(packId.uuidString)/invite-codes/\(codeId.uuidString)"
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
        case .getProfile, .listPacks, .getPack, .getPackMembers, .getPackStats,
             .listInviteCodes, .validateInviteCode,
             .listGoals, .listPackGoals, .getGoal,
             .getTasks, .getFeed, .getPost:
            return .get
        case .registerPushToken, .createPack, .createInviteCode, .useInviteCode,
             .createPackGoal, .createTask:
            return .post
        case .updateProfile, .updatePack, .deactivateInviteCode, .updateGoal, .updateTask:
            return .patch
        case .deletePushToken, .dissolvePack, .removePackMember, .deleteInviteCode,
             .deleteGoal, .deleteTask:
            return .delete
        }
    }

    var body: Data? {
        switch self {
        case .updateProfile(let request):
            return try? JSONEncoder().encode(request)
        case .registerPushToken(let request):
            return try? JSONEncoder().encode(request)
        case .createPack(let request):
            return try? JSONEncoder().encode(request)
        case .updatePack(_, let request):
            return try? JSONEncoder().encode(request)
        case .createInviteCode(_, let request):
            return try? JSONEncoder().encode(request)
        case .useInviteCode(let request):
            return try? JSONEncoder().encode(request)
        case .createPackGoal(_, let request):
            return try? JSONEncoder().encode(request)
        case .updateGoal(_, let request):
            return try? JSONEncoder().encode(request)
        case .createTask(_, let data), .updateTask(_, let data):
            return data
        default:
            return nil
        }
    }

    var headers: [String: String]? {
        return APIConfiguration.defaultHeaders
    }
}
