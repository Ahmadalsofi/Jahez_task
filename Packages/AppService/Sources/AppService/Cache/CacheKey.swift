import Foundation

/// Type that pairs a cache key string with the value type it stores.
/// Prevents mismatched key/type lookups at compile time.
public struct CacheKey<T: Codable> {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - Typed overloads on CacheStore

public extension CacheStore {
    func save<T: Codable>(_ value: T, forKey key: CacheKey<T>) {
        save(value, forKey: key.rawValue)
    }

    func load<T: Codable>(forKey key: CacheKey<T>) -> T? {
        load(forKey: key.rawValue)
    }

    func remove<T: Codable>(forKey key: CacheKey<T>) {
        remove(forKey: key.rawValue)
    }
}
