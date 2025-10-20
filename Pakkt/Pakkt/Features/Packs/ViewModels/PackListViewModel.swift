import Foundation

struct Pack: Identifiable, Codable {
    let id: String
    let userId: String
    let title: String
    let description: String?
    let color: String
    let tasksCount: Int
    let completedCount: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case description
        case color
        case tasksCount = "tasks_count"
        case completedCount = "completed_count"
        case createdAt = "created_at"
    }
}

struct Task: Identifiable, Codable {
    let id: String
    let packId: String
    let title: String
    let description: String?
    let isCompleted: Bool
    let dueDate: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case packId = "pack_id"
        case title
        case description
        case isCompleted = "is_completed"
        case dueDate = "due_date"
        case createdAt = "created_at"
    }
}

@MainActor
class PackListViewModel: BaseViewModel {
    @Published var packs: [Pack] = []
    @Published var isRefreshing = false

    func loadPacks() async {
        do {
            let packs: [Pack] = try await withLoading {
                try await APIClient.shared.request(PakktEndpoint.getPacks)
            }
            self.packs = packs
        } catch {
            handleError(error)
        }
    }

    func refreshPacks() async {
        isRefreshing = true
        defer { isRefreshing = false }

        await loadPacks()
    }

    func createPack(title: String, description: String?, color: String) async {
        do {
            let packData: [String: Any] = [
                "title": title,
                "description": description ?? "",
                "color": color
            ]

            guard let data = try? JSONSerialization.data(withJSONObject: packData) else {
                throw APIError.invalidURL
            }

            try await withLoading {
                try await APIClient.shared.request(PakktEndpoint.createPack(data: data))
            }

            await loadPacks()
        } catch {
            handleError(error)
        }
    }

    func deletePack(_ packId: String) async {
        do {
            try await withLoading {
                try await APIClient.shared.request(PakktEndpoint.deletePack(id: packId))
            }

            packs.removeAll { $0.id == packId }
        } catch {
            handleError(error)
        }
    }
}
