import Combine
import NetworkKit

public final class CachedGenreService: GenreService {
    private let wrapped: GenreService
    private let cache: any CacheStore

    public init(wrapped: GenreService, cache: any CacheStore) {
        self.wrapped = wrapped
        self.cache = cache
    }

    public func fetchGenres() -> AnyPublisher<[Genre], NetworkError> {
        wrapped.fetchGenres().caching(to: cache, key: .genres)
    }
}

private extension CacheKey where T == [Genre] {
    static let genres = CacheKey("genres")
}
