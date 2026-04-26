import Combine
import AppService
import Foundation

final class GenreFilterViewModel: ObservableObject {
    @Published private(set) var genres: [Genre] = []
    @Published private(set) var selectedGenreId: Int?

    private let genreService: GenreService
    private var cancellables = Set<AnyCancellable>()

    init(genreService: GenreService) {
        self.genreService = genreService
    }

    func load() {
        genreService.fetchGenres()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.genres = $0 }
            )
            .store(in: &cancellables)
    }

    func selectGenre(id: Int) {
        selectedGenreId = selectedGenreId == id ? nil : id
    }
}
