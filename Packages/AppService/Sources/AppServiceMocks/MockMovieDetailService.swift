import Combine
import NetworkKit
import AppService

public final class MockMovieDetailService: MovieDetailService {
    public var result: Result<MovieDetail, NetworkError> = .failure(.unknown("No result set"))

    public init() {}

    public func fetchMovieDetail(id: Int) -> AnyPublisher<MovieDetail, NetworkError> {
        result.publisher.eraseToAnyPublisher()
    }
}
