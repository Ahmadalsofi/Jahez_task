import UIKit

actor ImageCache {
    static let shared = ImageCache()

    private let memory = NSCache<NSString, UIImage>()
    private let diskURL: URL = {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let dir = caches.appendingPathComponent("SharedUI.ImageCache", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }()

    func image(for url: URL) -> UIImage? {
        let key = cacheKey(for: url)
        if let cached = memory.object(forKey: key as NSString) { return cached }
        let fileURL = diskURL.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) else { return nil }
        memory.setObject(image, forKey: key as NSString)
        return image
    }

    func store(_ image: UIImage, for url: URL) {
        let key = cacheKey(for: url)
        memory.setObject(image, forKey: key as NSString)
        let fileURL = diskURL.appendingPathComponent(key)
        try? image.jpegData(compressionQuality: 0.85)?.write(to: fileURL)
    }

    private func cacheKey(for url: URL) -> String {
        url.absoluteString
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ":", with: "-")
    }
}
