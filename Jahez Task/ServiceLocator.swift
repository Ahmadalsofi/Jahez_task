import NetworkKit
import AppService
import Foundation

final class ServiceLocator {

    static let shared = ServiceLocator()

    let genreService: GenreService
    let movieService: MovieService
    let movieDetailService: MovieDetailService

    private convenience init() {
        self.init(httpClient: Self.makeHTTPClient())
    }

    // Testable path — inject any HTTPClient, TMDBConfiguration, and CacheStore.
    init(
        httpClient: HTTPClient,
        tmdbConfig: TMDBConfiguration = .fromBundle(),
        cache: CacheStore = DiskCacheStore()
    ) {
        genreService = CachedGenreService(
            wrapped: GenreServiceImplementation(client: httpClient, config: tmdbConfig),
            cache: cache
        )
        movieService = CachedMovieService(
            wrapped: MovieServiceImplementation(client: httpClient, config: tmdbConfig),
            cache: cache
        )
        movieDetailService = MovieDetailServiceImplementation(client: httpClient, config: tmdbConfig)
    }

    private static func makeHTTPClient() -> HTTPClient {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return URLSessionHTTPClient(decoder: decoder, configuration: .debug)
    }
}

