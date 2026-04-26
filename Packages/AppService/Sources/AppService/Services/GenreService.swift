import Combine
import NetworkKit

public protocol GenreService {
    func fetchGenres() -> AnyPublisher<[Genre], NetworkError>
}
