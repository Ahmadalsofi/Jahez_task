import XCTest
import Combine
@testable import NetworkKit

final class URLSessionHTTPClientTests: XCTestCase {

    private var sut: URLSessionHTTPClient!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        sut = URLSessionHTTPClient(session: URLSession(configuration: config))
    }

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Success

    func test_request_decodesValidJSONResponse() {
        let json = #"{"id": 42, "name": "Inception"}"#.data(using: .utf8)!
        stub(statusCode: 200, data: json)

        let result = waitForValue(sut.request(StubEndpoint()) as AnyPublisher<Movie, NetworkError>)

        XCTAssertEqual(result, Movie(id: 42, name: "Inception"))
    }

    // MARK: - HTTP Errors

    func test_request_401_returnsUnauthorized() {
        stub(statusCode: 401, data: Data())

        let error = waitForError(sut.request(StubEndpoint()) as AnyPublisher<Movie, NetworkError>)

        XCTAssertEqual(error, .unauthorized)
    }

    func test_request_500_returnsServerError() {
        stub(statusCode: 500, data: Data())

        let error = waitForError(sut.request(StubEndpoint()) as AnyPublisher<Movie, NetworkError>)

        XCTAssertEqual(error, .serverError(statusCode: 500))
    }

    func test_request_404_returnsServerError() {
        stub(statusCode: 404, data: Data())

        let error = waitForError(sut.request(StubEndpoint()) as AnyPublisher<Movie, NetworkError>)

        XCTAssertEqual(error, .serverError(statusCode: 404))
    }

    // MARK: - Decoding Error

    func test_request_invalidJSON_returnsDecodingFailed() {
        stub(statusCode: 200, data: Data("not-json".utf8))

        let error = waitForError(sut.request(StubEndpoint()) as AnyPublisher<Movie, NetworkError>)

        guard case .decodingFailed = error else {
            XCTFail("Expected decodingFailed, got \(String(describing: error))")
            return
        }
    }

    // MARK: - No Connectivity

    func test_request_noConnectivity_returnsNoConnectivityError() {
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        let error = waitForError(sut.request(StubEndpoint()) as AnyPublisher<Movie, NetworkError>)

        XCTAssertEqual(error, .noConnectivity)
    }

    // MARK: - Invalid URL

    func test_request_invalidURL_returnsInvalidURLError() {
        let error = waitForError(sut.request(ThrowingEndpoint()) as AnyPublisher<Movie, NetworkError>)

        XCTAssertEqual(error, .invalidURL)
    }
}

// MARK: - Helpers

private extension URLSessionHTTPClientTests {

    func stub(statusCode: Int, data: Data) {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
    }
}

// MARK: - Test Doubles

private struct Movie: Decodable, Equatable {
    let id: Int
    let name: String
}

private struct StubEndpoint: Endpoint {
    var baseURL: URL       { URL(string: "https://api.test.com")! }
    var path: String       { "/movies" }
    var method: HTTPMethod { .get }
    var headers: [String: String] { [:] }
    var queryParameters: [String: String] { [:] }
}

private struct ThrowingEndpoint: Endpoint {
    var baseURL: URL       { URL(string: "https://api.test.com")! }
    var path: String       { "" }
    var method: HTTPMethod { .get }
    var headers: [String: String] { [:] }
    var queryParameters: [String: String] { [:] }

    func urlRequest() throws -> URLRequest {
        throw NetworkError.invalidURL
    }
}
