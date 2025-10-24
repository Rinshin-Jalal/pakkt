// app/Pakkt/Features/Jail/Models/JailSession.swift
import Foundation

enum JailStatus: String, Codable {
    case active
    case completed
    case broken
}

struct JailSession: Codable, Identifiable, Equatable {
    let id: UUID
    let userId: UUID
    let packId: UUID
    let goalId: UUID
    let fineId: UUID?
    let durationMinutes: Int
    let blockedApps: [String]
    let status: JailStatus
    let startedAt: Date
    let lastHeartbeatAt: Date?
    let pausedAt: Date?
    let totalPausedDuration: Int // In seconds
    let completedAt: Date?
    let createdAt: Date
    let updatedAt: Date
    let user: JailUser?
    let goal: JailGoal?

    struct JailUser: Codable, Equatable {
        let username: String
        let profilePic: String?
    }

    struct JailGoal: Codable, Equatable {
        let title: String
    }
}

struct JailSessionWithProgress: Codable, Identifiable, Equatable {
    let id: UUID
    let userId: UUID
    let packId: UUID
    let goalId: UUID
    let fineId: UUID?
    let durationMinutes: Int
    let blockedApps: [String]
    let status: JailStatus
    let startedAt: Date
    let elapsedMinutes: Int
    let remainingMinutes: Int
    let progressPercentage: Double
    let isPaused: Bool
    let canBreak: Bool
    let breakFineAmount: Int
}

struct StartJailRequest: Codable {
    let goalId: UUID
    let fineId: UUID?
    let durationMinutes: Int?
    let blockedApps: [String]
}

struct JailSessionResponse: Codable {
    let success: Bool
    let data: JailSession
}

struct JailSessionWithProgressResponse: Codable {
    let success: Bool
    let data: JailSessionWithProgress
}