import SwiftUI

public struct MediaCard: View {
    let imageURL: URL?
    let title: String
    let subtitle: String?
    let cornerRadius: CGFloat

    public init(
        imageURL: URL?,
        title: String,
        subtitle: String? = nil,
        cornerRadius: CGFloat = 10
    ) {
        self.imageURL = imageURL
        self.title = title
        self.subtitle = subtitle
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            CachedAsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure, .empty:
                    Color.imagePlaceholder
                        .overlay(Image(systemName: "film").foregroundStyle(.secondary))
                @unknown default:
                    Color.imagePlaceholder
                }
            }
            .aspectRatio(2/3, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(2)

            if let subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
