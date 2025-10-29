import Foundation

struct APIConfiguration {
    // Backend API Configuration
    #if DEBUG
    static let baseURL = "http://localhost:8787" // Local development
    #else
    static let baseURL = "https://pakkt-api.workers.dev" // Production Cloudflare Worker
    #endif
    
    // Supabase Configuration (for Realtime)
    static let supabaseURL = "https://nuqzzthltpudacpjdyfy.supabase.co"
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im51cXp6dGhsdHB1ZGFjcGpkeWZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk2NDk5MjksImV4cCI6MjA0NTIyNTkyOX0.7cWY0YEfT7BZJjE6EEQ94vkZ6SfC7lOm1eAXkDRW86I"

    static var defaultHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
        ]
    }
}
