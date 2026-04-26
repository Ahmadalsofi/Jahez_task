import Combine
import Foundation
import NetworkKit

public final class MockHTTPClient: HTTPClient {
    public var result: Result<Any, NetworkError>?

    public init() {}

    public func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        switch result {
        case .success(let value):
            if let typed = value as? T {
                return Just(typed)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
            }
            return Fail(error: .unknown("MockHTTPClient: type mismatch — expected \(T.self)"))
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        case nil:
            return Fail(error: .unknown("MockHTTPClient: result not set"))
                .eraseToAnyPublisher()
        }
    }
}
