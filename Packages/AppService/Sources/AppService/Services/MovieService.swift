import Combine
import NetworkKit

public protocol MovieService {
    func fetchMovies(genreId: Int?, page: Int) -> AnyPublisher<MovieListResponse, NetworkError>
}
