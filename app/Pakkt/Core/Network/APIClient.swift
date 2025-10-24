import Foundation

actor APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let keychainService: KeychainService
    private var requestLogger: ((URLRequest) -> Void)?
    private var responseLogger: ((URLResponse, Data?) -> Void)?

    init(keychainService: KeychainService = KeychainService()) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true
        self.session = URLSession(configuration: configuration)
        self.keychainService = keychainService
    }

    // MARK: - Logging

    func enableLogging(
        request: @escaping (URLRequest) -> Void,
        response: @escaping (URLResponse, Data?) -> Void
    ) {
        self.requestLogger = request
        self.responseLogger = response
    }

    // MARK: - Request with Response

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let urlRequest = try await buildURLRequest(from: endpoint)

        requestLogger?(urlRequest)

        let (data, response) = try await session.data(for: urlRequest)

        responseLogger?(response, data)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        try validateResponse(httpResponse, data: data)

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    // MARK: - Request without Response

    func request(_ endpoint: Endpoint) async throws {
        let urlRequest = try buildURLRequest(from: endpoint)

        requestLogger?(urlRequest)

        let (data, response) = try await session.data(for: urlRequest)

        responseLogger?(response, data)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        try validateResponse(httpResponse, data: data)
    }

    // MARK: - Private Helpers

    private func buildURLRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard let url = buildURL(from: endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        // Set headers
        var headers = endpoint.headers ?? [:]

        // Add Content-Type if body present
        if endpoint.body != nil && headers["Content-Type"] == nil {
            headers["Content-Type"] = "application/json"
        }

        // Inject auth token from Keychain
        if let token = try? keychainService.getAuthToken() {
            headers["Authorization"] = "Bearer \(token)"
        }

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }

    private func buildURL(from endpoint: Endpoint) -> URL? {
        var components = URLComponents(string: APIConfiguration.baseURL + endpoint.path)
        components?.queryItems = endpoint.queryItems
        return components?.url
    }

    private func validateResponse(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 401:
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 404:
            throw APIError.notFound
        case 400...499:
            // Try to decode error message from body
            if let errorMessage = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.clientError(statusCode: response.statusCode, message: errorMessage.message)
            }
            throw APIError.clientError(statusCode: response.statusCode, message: nil)
        case 500...599:
            throw APIError.serverError(statusCode: response.statusCode, message: nil)
        default:
            throw APIError.serverError(statusCode: response.statusCode, message: nil)
        }
    }
}

