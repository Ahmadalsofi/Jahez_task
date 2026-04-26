import Combine
import Foundation

public final class URLSessionHTTPClient: HTTPClient {

    private let session: URLSession
    private let decoder: JSONDecoder
    private let logger: NetworkLogger

    public init(
        session: URLSession? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        configuration: NetworkConfiguration = .default
    ) {
        if let session {
            self.session = session
        } else {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = configuration.timeoutInterval
            self.session = URLSession(configuration: config)
        }
        self.decoder = decoder
        self.logger = NetworkLogger(isEnabled: configuration.loggingEnabled)
    }

    public func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        do {
            let urlRequest = try endpoint.urlRequest()
            logger.logRequest(urlRequest)

            return session
                .dataTaskPublisher(for: urlRequest)
                .tryMap { [logger] data, response -> Data in
                    guard let http = response as? HTTPURLResponse else {
                        throw NetworkError.unknown("Non-HTTP response received")
                    }
                    logger.logResponse(http, data: data)
                    switch http.statusCode {
                    case 200...299:
                        return data
                    case 401:
                        throw NetworkError.unauthorized
                    default:
                        throw NetworkError.serverError(statusCode: http.statusCode)
                    }
                }
                .decode(type: T.self, decoder: decoder)
                .mapError { [logger] error -> NetworkError in
                    let mapped = NetworkError.map(error)
                    logger.logError(mapped, url: urlRequest.url)
                    return mapped
                }
                .eraseToAnyPublisher()

        } catch let error as NetworkError {
            logger.logError(error, url: nil)
            return Fail(error: error).eraseToAnyPublisher()
        } catch {
            let mapped = NetworkError.unknown(error.localizedDescription)
            logger.logError(mapped, url: nil)
            return Fail(error: mapped).eraseToAnyPublisher()
        }
    }
}

// MARK: - Error mapping

private extension NetworkError {
    static func map(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError { return networkError }
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet { return .noConnectivity }
        if error is DecodingError { return .decodingFailed(error.localizedDescription) }
        return .unknown(error.localizedDescription)
    }
}
