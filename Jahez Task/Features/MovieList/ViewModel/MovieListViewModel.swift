import Combine
import Foundation
import AppService

final class MovieListViewModel: ObservableObject {

    @Published var searchText: String = ""
    @Published var selectedGenreId: Int?
    @Published private(set) var state: UIState<Void> = .idle
    @Published private(set) var isLoadingMore = false

    private var paginator = Paginator<Movie>()
    private let movieService: MovieService
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?

    var movies: [Movie] {
        let items = paginator.items
        guard selectedGenreId != nil || !searchText.isEmpty else { return items }
        return items.filter(matches)
    }

    init(movieService: MovieService) {
        self.movieService = movieService
    }

    private func matches(_ movie: Movie) -> Bool {
        let matchesGenre = selectedGenreId.map { movie.genreIds.contains($0) } ?? true
        let matchesSearch = searchText.isEmpty || movie.title.localizedCaseInsensitiveContains(searchText)
        return matchesGenre && matchesSearch
    }
    
    private func fetchPage(_ page: Int) {
        movieService.fetchMovies(genreId: nil, page: page)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    isLoadingMore = false
                    if case .failure(let error) = completion, case .loading = state {
                        state = .error(error.userFacingMessage)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    isLoadingMore = false
                    paginator.apply(page: response.page,
                                    totalPages: response.totalPages,
                                    results: response.results)
                    state = .loaded(())
                }
            )
            .store(in: &cancellables)
    }
    
    func load() {
        guard case .idle = state else { return }
        state = .loading
        fetchPage(paginator.nextPage)
    }
    
    func reload() {
        cancellables.removeAll()
        paginator.reset()
        state = .idle
        load()
    }
    
    func loadNextPage() {
        guard searchText.isEmpty, selectedGenreId == nil else { return }
        guard !isLoadingMore, paginator.hasNextPage, case .loaded = state else { return }
        isLoadingMore = true
        fetchPage(paginator.nextPage)
    }
}
