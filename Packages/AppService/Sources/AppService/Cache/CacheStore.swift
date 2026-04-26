public protocol CacheStore {
    func save<T: Encodable>(_ value: T, forKey key: String)
    func load<T: Decodable>(forKey key: String) -> T?
    func remove(forKey key: String)
    func clearAll()
}
