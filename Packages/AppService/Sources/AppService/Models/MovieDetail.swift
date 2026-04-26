import Foundation

public struct MovieDetail: Decodable, Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let tagline: String?
    public let posterPath: String?
    public let backdropPath: String?
    public let releaseDate: String?
    public let genres: [Genre]
    public let overview: String
    public let homepage: String?
    public let budget: Int
    public let revenue: Int
    public let spokenLanguages: [SpokenLanguage]
    public let status: String
    public let runtime: Int?

    public init(
        id: Int, title: String, tagline: String? = nil,
        posterPath: String? = nil, backdropPath: String? = nil,
        releaseDate: String? = nil, genres: [Genre] = [],
        overview: String = "", homepage: String? = nil,
        budget: Int = 0, revenue: Int = 0,
        spokenLanguages: [SpokenLanguage] = [],
        status: String = "Released", runtime: Int? = nil
    ) {
        self.id = id; self.title = title; self.tagline = tagline
        self.posterPath = posterPath; self.backdropPath = backdropPath
        self.releaseDate = releaseDate; self.genres = genres
        self.overview = overview; self.homepage = homepage
        self.budget = budget; self.revenue = revenue
        self.spokenLanguages = spokenLanguages
        self.status = status; self.runtime = runtime
    }

    public var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w342\(path)")
    }

    public var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }

    public var releaseMonthYear: String {
        releaseDate ?? ""
    }

    public var formattedBudget: String {
        "\(budget)"
    }

    public var formattedRevenue: String {
        "\(revenue)"
    }

    public var formattedRuntime: String {
         "\(runtime ?? 0) minutes"
    }

    public var genresDisplay: String {
        genres.map(\.name).joined(separator: ", ")
    }

    public var spokenLanguagesDisplay: String {
        spokenLanguages.map(\.englishName).joined(separator: ", ")
    }
}

public struct SpokenLanguage: Decodable, Sendable {
    public let englishName: String
    public let name: String
}
