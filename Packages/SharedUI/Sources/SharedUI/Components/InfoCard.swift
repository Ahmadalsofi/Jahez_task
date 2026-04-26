import SwiftUI

public struct InfoCard: View {
    let title: String
    let value: String
    let isLink: Bool

    public init(title: String, value: String, isLink: Bool = false) {
        self.title = title
        self.value = value
        self.isLink = isLink
    }

    public var body: some View {
        HStack(spacing: 6) {
            TextLabel(title, style: .headline)
            if isLink, let url = URL(string: value) {
                Link(value, destination: url)
                    .font(.caption)
                    .foregroundStyle(.blue)
                    .lineLimit(1)
            } else {
                TextLabel(value, style: .caption)
            }
        }
    }
}
