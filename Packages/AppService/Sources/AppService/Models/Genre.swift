public struct Genre: Codable, Identifiable, Equatable, Sendable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public struct GenreResponse: Decodable {
    public let genres: [Genre]
}
