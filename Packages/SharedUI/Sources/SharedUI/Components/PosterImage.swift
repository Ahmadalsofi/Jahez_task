import SwiftUI

public struct PosterImage: View {
    let url: URL?
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat

    public init(
        url: URL?,
        width: CGFloat = 60,
        height: CGFloat = 90,
        cornerRadius: CGFloat = 8
    ) {
        self.url = url
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image.resizable().aspectRatio(contentMode: .fill)
            case .failure, .empty:
                Color.secondary.opacity(0.15)
                    .overlay(Image(systemName: "film").foregroundStyle(.secondary))
            @unknown default:
                Color.secondary.opacity(0.15)
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(color: .shadowOverlay, radius: 10, y: 4)
    }
}
