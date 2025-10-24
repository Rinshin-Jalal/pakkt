import Foundation

struct CreatePackRequest: Codable {
    let name: String
    let goalType: String?

    init(name: String, goalType: String? = nil) {
        self.name = name
        self.goalType = goalType
    }
}

struct UpdatePackRequest: Codable {
    let name: String?
    let description: String?

    init(name: String? = nil, description: String? = nil) {
        self.name = name
        self.description = description
    }
}
