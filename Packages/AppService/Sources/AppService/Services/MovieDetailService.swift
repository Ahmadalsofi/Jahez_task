import Combine
import NetworkKit

public protocol MovieDetailService {
    func fetchMovieDetail(id: Int) -> AnyPublisher<MovieDetail, NetworkError>
}
