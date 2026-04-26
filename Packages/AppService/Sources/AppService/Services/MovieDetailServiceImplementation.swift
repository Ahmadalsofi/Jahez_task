import Combine
import Foundation
import NetworkKit

public final class MovieDetailServiceImplementation: MovieDetailService {

    private let client: HTTPClient
    private let config: TMDBConfiguration

    public init(client: HTTPClient, config: TMDBConfiguration) {
        self.client = client
        self.config = config
    }

    public func fetchMovieDetail(id: Int) -> AnyPublisher<MovieDetail, NetworkError> {
        client.request(MovieDetailEndpoint(config: config, movieId: id))
    }
}

// MARK: - Endpoint

private struct MovieDetailEndpoint: Endpoint {
    let config: TMDBConfiguration
    let movieId: Int

    var baseURL: URL       { config.baseURL }
    var path: String       { "/movie/\(movieId)" }
    var method: HTTPMethod { .get }
    var headers: [String: String] { config.headers }
    var queryParameters: [String: String] { ["language": "en-US"] }
}
