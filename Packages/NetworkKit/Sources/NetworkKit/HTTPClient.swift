import Combine

/// The public abstraction for making network requests.
/// All other modules depend only on this protocol, never on the concrete type.
public protocol HTTPClient {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError>
}
