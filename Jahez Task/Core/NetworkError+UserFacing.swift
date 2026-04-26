import NetworkKit
extension NetworkError {
    var userFacingMessage: String {
        switch self {
        case .noConnectivity:
            return "No internet connection. Please check your network and try again."
        case .unauthorized:
            return "Session expired. Please restart the app."
        case .serverError(let code):
            return "Server error (\(code)). Please try again later."
        case .decodingFailed:
            return "Unable to read server response. Please try again."
        case .invalidURL:
            return "Invalid request. Please contact support."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
