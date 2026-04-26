import XCTest
import Combine
import NetworkKit
import AppServiceMocks
@testable import AppService

final class MovieServiceImplementationTests: XCTestCase {

    private var sut: MovieServiceImplementation!
    private var mockClient: MockHTTPClient!
    private var cancellables: Set<AnyCancellable>!

    private let testConfig = TMDBConfiguration(
        baseURL: URL(string: "https://api.test.com")!,
        bearerToken: "test-token"
    )

    override func setUp() {
        super.setUp()
        mockClient = MockHTTPClient()
        sut = MovieServiceImplementation(client: mockClient, config: testConfig)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        mockClient = nil
        super.tearDown()
    }

    func test_fetchMovies_returnsMovieList() {
        let expected = [Movie(id: 1, title: "Inception", posterPath: nil, releaseDate: "2010-07-16", genreIds: [28], overview: "A dream within a dream.")]
        mockClient.result = .success(MovieListResponse(page: 1, results: expected, totalPages: 1, totalResults: 1))

        let result = waitForValue(sut.fetchMovies(genreId: nil, page: 1))

        XCTAssertEqual(result?.results, expected)
    }

    func test_fetchMovies_withGenreId_returnsFilteredMovies() {
        let expected = [Movie(id: 2, title: "Mad Max", posterPath: nil, releaseDate: "2015-05-15", genreIds: [28], overview: "Fury Road.")]
        mockClient.result = .success(MovieListResponse(page: 1, results: expected, totalPages: 1, totalResults: 1))

        let result = waitForValue(sut.fetchMovies(genreId: 28, page: 1))

        XCTAssertEqual(result?.results, expected)
    }

    func test_fetchMovies_propagatesError() {
        mockClient.result = .failure(.noConnectivity)

        let error = waitForError(sut.fetchMovies(genreId: nil, page: 1))

        XCTAssertEqual(error, .noConnectivity)
    }
}
