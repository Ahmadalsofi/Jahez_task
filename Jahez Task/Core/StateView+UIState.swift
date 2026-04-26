import SharedUI
import SwiftUI
extension StateView {
    init<T>(
        state: UIState<T>,
        retryAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            isLoading: state.isLoading,
            errorMessage: state.errorMessage,
            retryAction: retryAction,
            content: content
        )
    }
}
