import SwiftUI

struct MoviePreviewCell: View {
    let movie: Movie

    private let posterWidth: CGFloat = 100
    private let posterHeight: CGFloat = 150

    var body: some View {
        VStack(spacing: 6) {
            AsyncImage(url: movie.posterURL) { phase in
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
                        .overlay(
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                        )
                }
            }

            Text(movie.title)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: posterWidth)
                .multilineTextAlignment(.center)

            if let rating = movie.voteAverage {
                CircularRatingView(rating: rating, textColor: .primary)
                    .padding(.vertical, 2)
            }
        }
        .frame(width: posterWidth)
    }
}
