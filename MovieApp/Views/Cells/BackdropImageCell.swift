import SwiftUI

struct BackdropImageCell: View {
    let imageURL: URL?

    private let imageWidth: CGFloat = 270
    private let imageHeight: CGFloat = 153

    var body: some View {
        ZStack {
            if let url = imageURL {
                AsyncImage(url: url) { phase in
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
                            .cornerRadius(12)
                    case .failure:
                        placeholder
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                placeholder
            }
        }
    }

    private var placeholder: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: imageWidth, height: imageHeight)
            .foregroundColor(.gray)
    }
}
