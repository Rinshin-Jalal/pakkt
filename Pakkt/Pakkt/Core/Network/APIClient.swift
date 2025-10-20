import Foundation

actor APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let maxRetries = 3

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
    }

    func request<T: Decodable>(
        _ endpoint: Endpoint,
        retryCount: Int = 0
    ) async throws -> T {
        guard let url = buildURL(from: endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw APIError.decodingError(error)
                }
            case 401:
                throw APIError.unauthorized
            case 403:
                throw APIError.forbidden
            case 404:
                throw APIError.notFound
            case 500...599:
                if retryCount < maxRetries {
                    try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(retryCount))) * 1_000_000_000)
                    return try await request(endpoint, retryCount: retryCount + 1)
                }
                throw APIError.serverError(statusCode: httpResponse.statusCode, message: nil)
            default:
                throw APIError.serverError(statusCode: httpResponse.statusCode, message: nil)
            }
        } catch let error as APIError {
            throw error
        } catch {
            if retryCount < maxRetries {
                try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(retryCount))) * 1_000_000_000)
                return try await request(endpoint, retryCount: retryCount + 1)
            }
            throw APIError.networkError(error)
        }
    }

    func request(_ endpoint: Endpoint, retryCount: Int = 0) async throws {
        guard let url = buildURL(from: endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        do {
            let (_, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200...299:
                return
            case 401:
                throw APIError.unauthorized
            case 403:
                throw APIError.forbidden
            case 404:
                throw APIError.notFound
            case 500...599:
                if retryCount < maxRetries {
                    try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(retryCount))) * 1_000_000_000)
                    return try await request(endpoint, retryCount: retryCount + 1)
                }
                throw APIError.serverError(statusCode: httpResponse.statusCode, message: nil)
            default:
                throw APIError.serverError(statusCode: httpResponse.statusCode, message: nil)
            }
        } catch let error as APIError {
            throw error
        } catch {
            if retryCount < maxRetries {
                try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(retryCount))) * 1_000_000_000)
                return try await request(endpoint, retryCount: retryCount + 1)
            }
            throw APIError.networkError(error)
        }
    }

    private func buildURL(from endpoint: Endpoint) -> URL? {
        var components = URLComponents(string: APIConfiguration.baseURL + endpoint.path)
        components?.queryItems = endpoint.queryItems
        return components?.url
    }
}
