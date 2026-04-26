import Foundation
import AppService

public final class InMemoryCacheStore: CacheStore {
    private var storage: [String: Data] = [:]
    private let queue = DispatchQueue(label: "com.app.memorycache")
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init() {}

    public func save<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? encoder.encode(value) else { return }
        queue.async { self.storage[key] = data }
    }

    public func load<T: Decodable>(forKey key: String) -> T? {
        queue.sync {
            guard let data = storage[key] else { return nil }
            return try? decoder.decode(T.self, from: data)
        }
    }

    public func remove(forKey key: String) {
        queue.async { self.storage.removeValue(forKey: key) }
    }

    public func clearAll() {
        queue.async { self.storage.removeAll() }
    }
}
