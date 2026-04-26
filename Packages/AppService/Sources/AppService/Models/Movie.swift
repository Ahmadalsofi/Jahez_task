import Foundation

public struct Movie: Codable, Identifiable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let posterPath: String?
    public let releaseDate: String?
    public let genreIds: [Int]
    public let overview: String

    public init(id: Int, title: String, posterPath: String?, releaseDate: String?, genreIds: [Int], overview: String) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.genreIds = genreIds
        self.overview = overview
    }

    public var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w342\(path)")
    }
}

public struct MovieListResponse: Codable {
    public let page: Int
    public let results: [Movie]
    public let totalPages: Int
    public let totalResults: Int

    public init(page: Int, results: [Movie], totalPages: Int, totalResults: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
