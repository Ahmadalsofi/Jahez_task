import Combine
import Foundation
import AppService

final class MovieDetailViewModel: ObservableObject {
    @Published private(set) var state: UIState<MovieDetail> = .idle

    private let movieId: Int
    private let service: MovieDetailService
    private var cancellables = Set<AnyCancellable>()

    init(movieId: Int, service: MovieDetailService) {
        self.movieId = movieId
        self.service = service
    }

    func load() {
        guard case .idle = state else { return }
        state = .loading

        service.fetchMovieDetail(id: movieId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state = .error(error.userFacingMessage)
                    }
                },
                receiveValue: { [weak self] detail in
                    self?.state = .loaded(detail)
                }
            )
            .store(in: &cancellables)
    }

    func reload() {
        state = .idle
        load()
    }
}
