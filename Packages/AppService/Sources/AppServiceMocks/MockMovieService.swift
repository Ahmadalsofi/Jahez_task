import Combine
import NetworkKit
import AppService

public final class MockMovieService: MovieService {
    public var result: Result<MovieListResponse, NetworkError> = .success(
        MovieListResponse(page: 1, results: [], totalPages: 0, totalResults: 0)
    )
    public private(set) var fetchCallCount = 0

    public init() {}

    public func fetchMovies(genreId: Int?, page: Int) -> AnyPublisher<MovieListResponse, NetworkError> {
        fetchCallCount += 1
        return result.publisher.eraseToAnyPublisher()
    }
}
