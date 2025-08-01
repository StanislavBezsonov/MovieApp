import SwiftUI

struct PosterImageCell: View {
    let imageURL: URL?

    private let imageWidth: CGFloat = 100
    private let imageHeight: CGFloat = 130

    var body: some View {
        VStack {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: imageWidth, height: imageHeight)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth, height: imageHeight)
                        .clipped()
                        .cornerRadius(8)
                case .failure:
                    placeholder
                @unknown default:
                    EmptyView()
                }
            }
        }
    }

    private var placeholder: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: imageWidth, height: imageHeight)
            .foregroundColor(.gray.opacity(0.5))
    }
}
