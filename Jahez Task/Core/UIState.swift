import Foundation
enum UIState<T> {
    case idle
    case loading
    case loaded(T)
    case error(String)

    var isLoading: Bool {
        switch self {
        case .idle, .loading: return true
        default: return false
        }
    }

    var value: T? {
        if case .loaded(let value) = self { return value }
        return nil
    }

    var errorMessage: String? {
        if case .error(let message) = self { return message }
        return nil
    }
}

extension UIState: Equatable where T: Equatable {}
