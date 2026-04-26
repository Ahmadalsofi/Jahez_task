import Combine
import Foundation
import NetworkKit

public final class MovieServiceImplementation: MovieService {

    private let client: HTTPClient
    private let config: TMDBConfiguration

    public init(client: HTTPClient, config: TMDBConfiguration) {
        self.client = client
        self.config = config
    }

    public func fetchMovies(genreId: Int?, page: Int) -> AnyPublisher<MovieListResponse, NetworkError> {
        client.request(MovieListEndpoint(config: config, genreId: genreId, page: page))
            .eraseToAnyPublisher()
    }
}

// MARK: - Endpoint

private struct MovieListEndpoint: Endpoint {
    let config: TMDBConfiguration
    let genreId: Int?
    let page: Int

    var baseURL: URL       { config.baseURL }
    var path: String       { "/discover/movie" }
    var method: HTTPMethod { .get }
    var headers: [String: String] { config.headers }
    var queryParameters: [String: String] {
        var params: [String: String] = [
            "include_adult": "false",
            "include_video": "false",
            "language": "en-US",
            "sort_by": "popularity.desc",
            "page": "\(page)"
        ]
        if let id = genreId { params["with_genres"] = "\(id)" }
        return params
    }
}
