import XCTest
import Combine
import AppService
import AppServiceMocks
@testable import Jahez_Task
internal import NetworkKit

final class MovieDetailViewModelTests: XCTestCase {

    private var sut: MovieDetailViewModel!
    private var mockService: MockMovieDetailService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockMovieDetailService()
        sut = MovieDetailViewModel(movieId: 1, service: mockService)
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

    func test_load_calledTwice_isIdempotent() {
        mockService.result = .success(detail(id: 1))
        sut.load()
        sut.load()
        guard case .loading = sut.state else {
            XCTFail("Expected .loading, got \(sut.state)"); return
        }
    }

    func test_load_onSuccess_setsLoadedDetail() {
        mockService.result = .success(detail(id: 1, title: "Inception"))
        let exp = expectation(description: "loaded")
        sut.$state.dropFirst().sink { if case .loaded = $0 { exp.fulfill() } }.store(in: &cancellables)

        sut.load()
        wait(for: [exp], timeout: 1)

        guard case .loaded(let movie) = sut.state else {
            XCTFail("Expected .loaded, got \(sut.state)"); return
        }
        XCTAssertEqual(movie.title, "Inception")
    }

    func test_load_onFailure_setsError() {
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

    func test_reload_afterSuccess_allowsAnotherLoad() {
        mockService.result = .success(detail(id: 1))
        let loadExp = expectation(description: "first load")
        sut.$state.dropFirst().sink { if case .loaded = $0 { loadExp.fulfill() } }.store(in: &cancellables)
        sut.load()
        wait(for: [loadExp], timeout: 1)
        cancellables.removeAll()

        mockService.result = .success(detail(id: 1, title: "Updated"))
        let reloadExp = expectation(description: "reload")
        sut.$state.dropFirst(2).sink { if case .loaded = $0 { reloadExp.fulfill() } }.store(in: &cancellables)
        sut.reload()
        wait(for: [reloadExp], timeout: 1)

        guard case .loaded(let movie) = sut.state else {
            XCTFail("Expected .loaded after reload"); return
        }
        XCTAssertEqual(movie.title, "Updated")
    }

    // MARK: - Fixtures

    private func detail(id: Int, title: String = "Test Movie") -> MovieDetail {
        MovieDetail(id: id, title: title)
    }
}
