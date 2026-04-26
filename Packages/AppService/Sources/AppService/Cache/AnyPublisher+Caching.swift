import Combine
import NetworkKit

extension AnyPublisher where Failure == NetworkError, Output: Codable {
    /// Saves each emitted value to `store` under `key`.
    /// On failure, falls back to the last cached value if one exists;
    /// otherwise re-throws the original error.
    func caching(to store: any CacheStore, key: CacheKey<Output>) -> AnyPublisher<Output, NetworkError> {
        handleEvents(receiveOutput: { store.save($0, forKey: key) })
            .catch { error -> AnyPublisher<Output, NetworkError> in
                if let cached: Output = store.load(forKey: key) {
                    return Just(cached).setFailureType(to: NetworkError.self).eraseToAnyPublisher()
                }
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
