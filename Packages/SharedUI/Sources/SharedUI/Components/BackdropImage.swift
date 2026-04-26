import SwiftUI

public struct BackdropImage: View {
    let url: URL?
    let height: CGFloat

    public init(url: URL?, height: CGFloat = 280) {
        self.url = url
        self.height = height
    }

    public var body: some View {
        CachedAsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image.resizable().aspectRatio(contentMode: .fill)
            default:
                Color.imagePlaceholder
            }
        }
        .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
        .clipped()
    }
}
