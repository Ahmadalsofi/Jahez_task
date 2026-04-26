import XCTest
import Combine
import AppService
import AppServiceMocks
@testable import Jahez_Task
internal import NetworkKit

final class MovieListViewModelTests: XCTestCase {

    private var sut: MovieListViewModel!
    private var mockService: MockMovieService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockMovieService()
        sut = MovieListViewModel(movieService: mockService)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - load()

    func test_load_setsStateToLoading() {
        sut.load()
        guard case .loading = sut.state else {
            XCTFail("Expected .loading, got \(sut.state)"); return
        }
    }

    func test_load_calledTwice_onlyFetchesOnce() {
        sut.load()
        sut.load()
        XCTAssertEqual(mockService.fetchCallCount, 1)
    }

    func test_load_onSuccess_populatesMovies() {
        mockService.result = .success(page(1, movies: [movie(1), movie(2)]))
        let exp = expectation(description: "loaded")
        sut.$state.dropFirst().sink { if case .loaded = $0 { exp.fulfill() } }.store(in: &cancellables)

        sut.load()
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(sut.movies.count, 2)
    }

    func test_load_onFailure_setsErrorMessage() {
        mockService.result = .failure(.noConnectivity)
        let exp = expectation(description: "error")
        sut.$state.dropFirst().sink { if case .error = $0 { exp.fulfill() } }.store(in: &cancellables)

        sut.load()
        wait(for: [exp], timeout: 1)

        guard case .error(let msg) = sut.state else {
            XCTFail("Expected .error, got \(sut.state)"); return
        }
        XCTAssertFalse(msg.isEmpty)
    }

    // MARK: - reload()

    func test_reload_resetsMoviesAndRefetches() {
        mockService.result = .success(page(1, movies: [movie(1)]))
        let loadExp = expectation(description: "initial load")
        sut.$state.dropFirst().sink { if case .loaded = $0 { loadExp.fulfill() } }.store(in: &cancellables)
        sut.load()
        wait(for: [loadExp], timeout: 1)
        cancellables.removeAll()

        mockService.result = .success(page(1, movies: [movie(99)]))
        let reloadExp = expectation(description: "reload")
        sut.$state.dropFirst(2).sink { if case .loaded = $0 { reloadExp.fulfill() } }.store(in: &cancellables)
        sut.reload()
        wait(for: [reloadExp], timeout: 1)

        XCTAssertEqual(sut.movies.map(\.id), [99])
    }

    // MARK: - loadNextPage()

    func test_loadNextPage_whenIdle_doesNothing() {
        sut.loadNextPage()
        guard case .idle = sut.state else {
            XCTFail("State should remain .idle"); return
        }
        XCTAssertEqual(mockService.fetchCallCount, 0)
    }

    func test_loadNextPage_appendsMoviesAndDeduplicates() {
        let duplicate = movie(1)
        mockService.result = .success(page(1, movies: [duplicate, movie(2)], totalPages: 2))
        let page1Exp = expectation(description: "page 1")
        sut.$state.dropFirst().sink { if case .loaded = $0 { page1Exp.fulfill() } }.store(in: &cancellables)
        sut.load()
        wait(for: [page1Exp], timeout: 1)
        cancellables.removeAll()

        mockService.result = .success(page(2, movies: [duplicate, movie(3)], totalPages: 2))
        let page2Exp = expectation(description: "page 2")
        sut.$state.dropFirst().sink { if case .loaded = $0 { page2Exp.fulfill() } }.store(in: &cancellables)
        sut.loadNextPage()
        wait(for: [page2Exp], timeout: 1)

        XCTAssertEqual(sut.movies.map(\.id).sorted(), [1, 2, 3])
    }

    // MARK: - Filtering

    func test_movies_genreFilter_showsMatchingOnly() {
        mockService.result = .success(page(1, movies: [movie(1, genreIds: [28]), movie(2, genreIds: [18])]))
        let exp = expectation(description: "loaded")
        sut.$state.dropFirst().sink { if case .loaded = $0 { exp.fulfill() } }.store(in: &cancellables)
        sut.load()
        wait(for: [exp], timeout: 1)

        sut.selectedGenreId = 28

        XCTAssertEqual(sut.movies.map(\.id), [1])
    }

    func test_movies_searchFilter_isCaseInsensitive() {
        mockService.result = .success(page(1, movies: [movie(1, title: "Inception"), movie(2, title: "Avatar")]))
        let exp = expectation(description: "loaded")
        sut.$state.dropFirst().sink { if case .loaded = $0 { exp.fulfill() } }.store(in: &cancellables)
        sut.load()
        wait(for: [exp], timeout: 1)

        sut.searchText = "inc"

        XCTAssertEqual(sut.movies.map(\.id), [1])
    }

    func test_movies_combinedFilter_requiresBothMatches() {
        mockService.result = .success(page(1, movies: [
            movie(1, title: "Inception", genreIds: [28]),
            movie(2, title: "Iron Man",  genreIds: [28]),
            movie(3, title: "Inception", genreIds: [18])
        ]))
        let exp = expectation(description: "loaded")
        sut.$state.dropFirst().sink { if case .loaded = $0 { exp.fulfill() } }.store(in: &cancellables)
        sut.load()
        wait(for: [exp], timeout: 1)

        sut.selectedGenreId = 28
        sut.searchText = "Inception"

        XCTAssertEqual(sut.movies.map(\.id), [1])
    }

    // MARK: - Fixtures

    private func movie(_ id: Int, title: String = "Movie", genreIds: [Int] = []) -> Movie {
        Movie(id: id, title: title, posterPath: nil, releaseDate: "2024-01-01", genreIds: genreIds, overview: "")
    }

    private func page(_ page: Int, movies: [Movie], totalPages: Int = 1) -> MovieListResponse {
        MovieListResponse(page: page, results: movies, totalPages: totalPages, totalResults: movies.count)
    }
}
