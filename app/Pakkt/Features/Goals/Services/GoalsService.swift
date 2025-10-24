import Foundation

actor GoalsService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - List Goals

    func listGoals() async throws -> [Goal] {
        let endpoint = PakktEndpoint.listGoals
        let response: GoalListResponse = try await apiClient.request(endpoint)
        return response.data
    }

    func listPackGoals(packId: UUID) async throws -> [Goal] {
        let endpoint = PakktEndpoint.listPackGoals(packId: packId)
        let response: GoalListResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Create Goal

    func createGoal(packId: UUID, request: CreateGoalRequest) async throws -> Goal {
        let endpoint = PakktEndpoint.createPackGoal(packId: packId, request: request)
        let response: GoalResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Get Goal

    func getGoal(id: UUID) async throws -> Goal {
        let endpoint = PakktEndpoint.getGoal(id: id)
        let response: GoalResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Update Goal

    func updateGoal(id: UUID, request: UpdateGoalRequest) async throws -> Goal {
        let endpoint = PakktEndpoint.updateGoal(id: id, request: request)
        let response: GoalResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Delete Goal

    func deleteGoal(id: UUID) async throws {
        let endpoint = PakktEndpoint.deleteGoal(id: id)
        try await apiClient.request(endpoint)
    }

    // MARK: - Get Goals Due Today

    func getGoalsDueToday() async throws -> [Goal] {
        let allGoals = try await listGoals()
        let today = Date()

        return allGoals.filter { goal in
            goal.isActive && goal.recurrenceRule.isScheduledFor(date: today)
        }
    }
}
