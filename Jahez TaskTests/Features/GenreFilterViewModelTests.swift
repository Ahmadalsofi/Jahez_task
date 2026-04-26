import XCTest
import Combine
import AppService
import AppServiceMocks
@testable import Jahez_Task
internal import NetworkKit

final class GenreFilterViewModelTests: XCTestCase {

    private var sut: GenreFilterViewModel!
    private var mockService: MockGenreService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockGenreService()
        sut = GenreFilterViewModel(genreService: mockService)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - load()

    func test_load_onSuccess_populatesGenres() {
        mockService.result = .success([Genre(id: 28, name: "Action"), Genre(id: 18, name: "Drama")])
        let exp = expectation(description: "genres populated")
        sut.$genres.dropFirst().sink { if !$0.isEmpty { exp.fulfill() } }.store(in: &cancellables)

        sut.load()
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(sut.genres.map(\.id), [28, 18])
    }

    func test_load_onFailure_genresRemainEmpty() {
        mockService.result = .failure(.noConnectivity)
        let exp = expectation(description: "sink fires")
        exp.isInverted = true
        sut.$genres.dropFirst().sink { _ in exp.fulfill() }.store(in: &cancellables)

        sut.load()
        wait(for: [exp], timeout: 0.3)

        XCTAssertTrue(sut.genres.isEmpty)
    }

    // MARK: - selectGenre()

    func test_selectGenre_setsSelectedId() {
        sut.selectGenre(id: 28)
        XCTAssertEqual(sut.selectedGenreId, 28)
    }

    func test_selectGenre_sameTwice_deselects() {
        sut.selectGenre(id: 28)
        sut.selectGenre(id: 28)
        XCTAssertNil(sut.selectedGenreId)
    }

    func test_selectGenre_differentId_replacesSelection() {
        sut.selectGenre(id: 28)
        sut.selectGenre(id: 18)
        XCTAssertEqual(sut.selectedGenreId, 18)
    }
}
