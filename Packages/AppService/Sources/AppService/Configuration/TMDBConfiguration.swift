import Foundation

public struct TMDBConfiguration {
    public let baseURL: URL
    public let bearerToken: String

    public var headers: [String: String] {
        ["Authorization": "Bearer \(bearerToken)", "accept": "application/json"]
    }

    public init(baseURL: URL, bearerToken: String) {
        self.baseURL = baseURL
        self.bearerToken = bearerToken
    }

    public static func fromBundle() -> TMDBConfiguration {
        let token = Bundle.main.object(forInfoDictionaryKey: "TMDB_BEARER_TOKEN") as? String ?? ""
        return TMDBConfiguration(
            baseURL: URL(string: "https://api.themoviedb.org/3")!,
            bearerToken: token
        )
    }
}
