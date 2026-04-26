import Combine
import Foundation
import NetworkKit

public final class GenreServiceImplementation: GenreService {

    private let client: HTTPClient
    private let config: TMDBConfiguration

    public init(client: HTTPClient, config: TMDBConfiguration) {
        self.client = client
        self.config = config
    }

    public func fetchGenres() -> AnyPublisher<[Genre], NetworkError> {
        client.request(GenreEndpoint(config: config))
            .map { (response: GenreResponse) in response.genres }
            .eraseToAnyPublisher()
    }
}

// MARK: - Endpoint

private struct GenreEndpoint: Endpoint {
    let config: TMDBConfiguration

    var baseURL: URL       { config.baseURL }
    var path: String       { "/genre/movie/list" }
    var method: HTTPMethod { .get }
    var headers: [String: String] { config.headers }
    var queryParameters: [String: String] { ["language": "en"] }
}
