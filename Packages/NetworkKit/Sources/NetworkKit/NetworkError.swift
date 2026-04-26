import Foundation

public enum NetworkError: Error, Equatable {
    case invalidURL
    case noConnectivity
    case unauthorized
    case serverError(statusCode: Int)
    case decodingFailed(String)
    case unknown(String)
}
