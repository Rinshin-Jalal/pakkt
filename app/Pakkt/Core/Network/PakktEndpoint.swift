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

    // Goals
    case listGoals
    case listPackGoals(packId: UUID)
    case createPackGoal(packId: UUID, request: CreateGoalRequest)
    case getGoal(id: UUID)
    case updateGoal(id: UUID, request: UpdateGoalRequest)
    case deleteGoal(id: UUID)

    // Check-ins
    case createCheckIn(CreateCheckInRequest)
    case getCheckIn(id: UUID)
    case getPackCheckIns(packId: UUID)

    // Uploads
    case getPresignedURL(PresignedURLRequest)

    // Social - Reactions
    case createReaction(CreateReactionRequest)
    case deleteReaction(id: UUID)
    case getReactions(checkInId: UUID)

    // Social - Comments
    case createComment(CreateCommentRequest)
    case editComment(id: UUID, request: EditCommentRequest)
    case deleteComment(id: UUID)
    case getComments(checkInId: UUID)

    // Fines
    case listPackFines(packId: UUID)
    case getFine(id: UUID)
    case voteOnFine(fineId: UUID, request: VoteRequest)
    case resolveFine(id: UUID)
    case appealFine(id: UUID, request: AppealRequest)

    // Jail
    case startJail(StartJailRequest)
    case getActiveJailSession
    case jailHeartbeat(sessionId: UUID)
    case completeJail(sessionId: UUID)
    case breakJail(sessionId: UUID, request: BreakJailRequest)

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
        case .listGoals:
            return "/api/goals"
        case .listPackGoals(let packId), .createPackGoal(let packId, _):
            return "/api/packs/\(packId.uuidString)/goals"
        case .getGoal(let id), .updateGoal(let id, _), .deleteGoal(let id):
            return "/api/goals/\(id.uuidString)"
        case .createCheckIn:
            return "/api/checkins"
        case .getFeed:
            return "/api/checkins/feed"
        case .getPackCheckIns(let packId):
            return "/api/packs/\(packId.uuidString)/checkins"
        case .getCheckIn(let id):
            return "/api/checkins/\(id.uuidString)"
        case .getPresignedURL:
            return "/api/uploads/presigned-url"
        case .createReaction:
            return "/api/social/reactions"
        case .deleteReaction(let id):
            return "/api/social/reactions/\(id.uuidString)"
        case .getReactions(let checkInId):
            return "/api/checkins/\(checkInId.uuidString)/reactions"
        case .createComment:
            return "/api/social/comments"
        case .editComment(let id, _), .deleteComment(let id):
            return "/api/social/comments/\(id.uuidString)"
        case .getComments(let checkInId):
            return "/api/checkins/\(checkInId.uuidString)/comments"
        case .listPackFines(let packId):
            return "/api/packs/\(packId.uuidString)/fines"
        case .getFine(let id):
            return "/api/fines/\(id.uuidString)"
        case .voteOnFine(let fineId, _):
            return "/api/fines/\(fineId.uuidString)/vote"
        case .resolveFine(let id):
            return "/api/fines/\(id.uuidString)/resolve"
        case .appealFine(let id, _):
            return "/api/fines/\(id.uuidString)/appeal"
        case .startJail:
            return "/api/jail/sessions"
        case .getActiveJailSession:
            return "/api/jail/sessions/active"
        case .jailHeartbeat(let sessionId):
            return "/api/jail/sessions/\(sessionId.uuidString)/heartbeat"
        case .completeJail(let sessionId):
            return "/api/jail/sessions/\(sessionId.uuidString)/complete"
        case .breakJail(let sessionId, _):
            return "/api/jail/sessions/\(sessionId.uuidString)/break"
        case .getTasks(let packId):
            return "/rest/v1/tasks?pack_id=eq.\(packId)"
        case .createTask:
            return "/rest/v1/tasks"
        case .updateTask(let id, _), .deleteTask(let id):
            return "/rest/v1/tasks?id=eq.\(id)"
        case .getPost(let id):
            return "/rest/v1/posts?id=eq.\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getProfile, .listPacks, .getPack, .getPackMembers, .getPackStats,
             .listInviteCodes, .validateInviteCode,
             .listGoals, .listPackGoals, .getGoal,
             .getCheckIn, .getPackCheckIns,
             .getReactions, .getComments,
             .listPackFines, .getFine,
             .getActiveJailSession,
             .getTasks, .getFeed, .getPost:
            return .get
        case .registerPushToken, .createPack, .createInviteCode, .useInviteCode,
             .createPackGoal, .createCheckIn, .getPresignedURL,
             .createReaction, .createComment,
             .voteOnFine, .resolveFine, .appealFine,
             .startJail, .breakJail, .completeJail,
             .createTask:
            return .post
        case .updateProfile, .updatePack, .deactivateInviteCode, .updateGoal,
             .editComment, .updateTask, .jailHeartbeat:
            return .patch
        case .deletePushToken, .dissolvePack, .removePackMember, .deleteInviteCode,
             .deleteGoal, .deleteReaction, .deleteComment, .deleteTask:
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
        case .createCheckIn(let request):
            return try? JSONEncoder().encode(request)
        case .getPresignedURL(let request):
            return try? JSONEncoder().encode(request)
        case .createReaction(let request):
            return try? JSONEncoder().encode(request)
        case .createComment(let request):
            return try? JSONEncoder().encode(request)
        case .editComment(_, let request):
            return try? JSONEncoder().encode(request)
        case .voteOnFine(_, let request):
            return try? JSONEncoder().encode(request)
        case .appealFine(_, let request):
            return try? JSONEncoder().encode(request)
        case .startJail(let request):
            return try? JSONEncoder().encode(request)
        case .breakJail(_, let request):
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
