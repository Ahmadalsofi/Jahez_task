import SwiftUI

public struct TextLabel: View {
    public enum Style {
        case title      
        case headline
        case body
        case caption
        case chip
    }

    private let text: String
    private let style: Style

    public init(_ text: String, style: Style) {
        self.text = text
        self.style = style
    }

    public var body: some View {
        switch style {
        case .title:
            Text(text)
                .font(.title3.bold())
                .foregroundStyle(.primary)
        case .headline:
            Text(text)
                .font(.headline)
                .foregroundStyle(.primary)
        case .body:
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineSpacing(4)
        case .caption:
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
        case .chip:
            Text(text)
                .font(.subheadline)
        }
    }
}
