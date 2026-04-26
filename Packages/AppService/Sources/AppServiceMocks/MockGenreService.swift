import Combine
import NetworkKit
import AppService

public final class MockGenreService: GenreService {
    public var result: Result<[Genre], NetworkError> = .success([])

    public init() {}

    public func fetchGenres() -> AnyPublisher<[Genre], NetworkError> {
        result.publisher.eraseToAnyPublisher()
    }
}
