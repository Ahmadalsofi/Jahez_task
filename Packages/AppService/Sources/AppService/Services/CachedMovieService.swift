import Combine
import NetworkKit

public final class CachedMovieService: MovieService {
    private let wrapped: MovieService
    private let cache: any CacheStore

    public init(wrapped: MovieService, cache: any CacheStore) {
        self.wrapped = wrapped
        self.cache = cache
    }

    public func fetchMovies(genreId: Int?, page: Int) -> AnyPublisher<MovieListResponse, NetworkError> {
        wrapped.fetchMovies(genreId: genreId, page: page)
            .caching(to: cache, key: .movies(genreId: genreId, page: page))
    }
}

private extension CacheKey where T == MovieListResponse {
    static func movies(genreId: Int?, page: Int) -> CacheKey<MovieListResponse> {
        CacheKey("movies_\(genreId.map(String.init) ?? "all")_page\(page)")
    }
}
