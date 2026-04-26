import SwiftUI

public struct ErrorPlaceholder: View {
    let message: String
    let retryAction: (() -> Void)?

    public init(message: String = "Something went wrong", retryAction: (() -> Void)? = nil) {
        self.message = message
        self.retryAction = retryAction
    }

    public var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title2)
                .foregroundStyle(Color.contentSecondary)
            TextLabel(message, style: .caption)
                .multilineTextAlignment(.center)
            if let retry = retryAction {
                Button(action: retry) {
                    TextLabel("Retry", style: .caption)
                        .fontWeight(.medium)
                }
                .padding(.top, 4)
            }
        }
        .padding()
    }
}
