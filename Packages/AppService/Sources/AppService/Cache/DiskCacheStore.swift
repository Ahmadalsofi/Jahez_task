import Foundation

public final class DiskCacheStore: CacheStore {
    private let directory: URL
    private let queue = DispatchQueue(label: "com.app.diskcache", qos: .utility)
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(subdirectory: String = "AppCache") {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        directory = base.appendingPathComponent(subdirectory)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    public func save<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? encoder.encode(value) else { return }
        let url = fileURL(for: key)
        queue.async { try? data.write(to: url, options: .atomic) }
    }

    public func load<T: Decodable>(forKey key: String) -> T? {
        let url = fileURL(for: key)
        return queue.sync {
            guard let data = try? Data(contentsOf: url) else { return nil }
            return try? decoder.decode(T.self, from: data)
        }
    }

    public func remove(forKey key: String) {
        let url = fileURL(for: key)
        queue.async { try? FileManager.default.removeItem(at: url) }
    }

    public func clearAll() {
        let dir = directory
        queue.async {
            try? FileManager.default.removeItem(at: dir)
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
    }

    private func fileURL(for key: String) -> URL {
        directory.appendingPathComponent("\(key).cache")
    }
}
