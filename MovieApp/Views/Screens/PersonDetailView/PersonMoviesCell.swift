import SwiftUI

struct PersonMoviesCell: View {
    let movie: Movie
    
    let imageWidth: CGFloat = 90
    let imageHeight: CGFloat = 135
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let url = movie.posterURL {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: imageWidth, height: imageHeight)
                .cornerRadius(6)
            } else {
                Color.gray.opacity(0.3)
                    .frame(width: imageWidth, height: imageHeight)
                    .cornerRadius(6)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(4)
                
                if let rating = movie.voteAverage {
                    CircularRatingView(rating: rating, textColor: .appBlack)
                }
            }
            .frame(maxHeight: imageHeight, alignment: .center)
        }
    }
}
