import Combine

final class MovieDiscoverViewModel: ObservableObject {
    let genreFilter: GenreFilterViewModel
    let movieList: MovieListViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(genreFilter: GenreFilterViewModel, movieList: MovieListViewModel) {
        self.genreFilter = genreFilter
        self.movieList = movieList
        bindGenreSelection()
    }
    
    func load() {
        genreFilter.load()
        movieList.load()
    }
    
    private func bindGenreSelection() {
        genreFilter.$selectedGenreId
            .sink { [weak movieList] genreId in
                movieList?.selectedGenreId = genreId
            }
            .store(in: &cancellables)
    }
}
