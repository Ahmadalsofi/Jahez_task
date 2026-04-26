import Foundation

/// Describes a single API request. Concrete types live in the Data layer.
public protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
    var body: Data? { get }

    /// Builds the final URLRequest. Declared as a protocol requirement so
    /// test doubles can override it cleanly.
    func urlRequest() throws -> URLRequest
}

public extension Endpoint {
    var body: Data? { nil }

    func urlRequest() throws -> URLRequest {
        guard
            var components = URLComponents(
                url: baseURL.appendingPathComponent(path),
                resolvingAgainstBaseURL: false
            )
        else {
            throw NetworkError.invalidURL
        }

        if !queryParameters.isEmpty {
            components.queryItems = queryParameters
                .sorted { $0.key < $1.key }
                .map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }
}
