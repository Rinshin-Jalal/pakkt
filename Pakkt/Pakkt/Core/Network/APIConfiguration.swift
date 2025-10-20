import Foundation

struct APIConfiguration {
    // Supabase Configuration
    static let supabaseURL = "https://nuqzzthltpudacpjdyfy.supabase.co"
    static let supabaseAnonKey = "sb_publishable_H6L4UeiDMU5oWUIyJADnQA_fU3c44lk"

    static var baseURL: String {
        return supabaseURL
    }

    static var defaultHeaders: [String: String] {
        return [
            "apikey": supabaseAnonKey,
            "Content-Type": "application/json",
        ]
    }
}
