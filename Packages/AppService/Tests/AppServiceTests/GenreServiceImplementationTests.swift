import XCTest
import Combine
import NetworkKit
import AppServiceMocks
@testable import AppService

final class GenreServiceImplementationTests: XCTestCase {

    private var sut: GenreServiceImplementation!
    private var mockClient: MockHTTPClient!
    private var cancellables: Set<AnyCancellable>!

    private let testConfig = TMDBConfiguration(
        baseURL: URL(string: "https://api.test.com")!,
        bearerToken: "test-token"
    )

    override func setUp() {
        super.setUp()
        mockClient = MockHTTPClient()
        sut = GenreServiceImplementation(client: mockClient, config: testConfig)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        mockClient = nil
        super.tearDown()
    }

    func test_fetchGenres_returnsGenreList() {
        let expected = [Genre(id: 28, name: "Action"), Genre(id: 12, name: "Adventure")]
        mockClient.result = .success(GenreResponse(genres: expected))

        let result = waitForValue(sut.fetchGenres())

        XCTAssertEqual(result, expected)
    }

    func test_fetchGenres_propagatesError() {
        mockClient.result = .failure(.unauthorized)

        let error = waitForError(sut.fetchGenres())

        XCTAssertEqual(error, .unauthorized)
    }
}
