import SwiftUI

struct MoviePreviewCell: View {
    let posterURL: URL?
    let title: String
    let rating: Double?

    private let posterWidth: CGFloat = 100
    private let posterHeight: CGFloat = 150

    var body: some View {
        VStack(spacing: 6) {
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: posterWidth, height: posterHeight)
                        .clipped()
                        .cornerRadius(8)
                default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: posterWidth, height: posterHeight)
                        .cornerRadius(8)
                }
            }

            Text(title)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: posterWidth)
                .multilineTextAlignment(.center)

            if let rating {
                CircularRatingView(rating: rating, textColor: .primary)
                    .padding(.vertical, 2)
            }
        }
        .frame(width: posterWidth)
    }
}
