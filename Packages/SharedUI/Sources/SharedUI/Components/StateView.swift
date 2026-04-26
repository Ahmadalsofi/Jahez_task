import SwiftUI

public struct StateView<Content: View>: View {
    let isLoading: Bool
    let errorMessage: String?
    let retryAction: (() -> Void)?
    @ViewBuilder let content: () -> Content

    public init(
        isLoading: Bool,
        errorMessage: String? = nil,
        retryAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isLoading = isLoading
        self.errorMessage = errorMessage
        self.retryAction = retryAction
        self.content = content
    }

    public var body: some View {
        if isLoading {
            ProgressView()
                .padding(.horizontal)
        } else if let message = errorMessage {
            ErrorPlaceholder(message: message, retryAction: retryAction)
        } else {
            content()
        }
    }
}
