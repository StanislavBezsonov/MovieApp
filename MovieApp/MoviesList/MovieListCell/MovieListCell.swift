import SwiftUI

struct MovieListCell: View {
    let movie: Movie
    private let imageWidth: CGFloat = 100
    private let imageHeight: CGFloat = 150

    private var placeholderImage: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: imageWidth, height: imageHeight)
            .foregroundColor(.gray)
    }
    
    private func formattedDate(from string: String?) -> String? {
        guard let string = string else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: string) {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return nil
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let posterPath = movie.posterPath,
               let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
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
                            .cornerRadius(8)
                    case .failure:
                        placeholderImage
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                placeholderImage
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if let dateString = formattedDate(from: movie.releaseDate) {
                    Text(dateString)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                if let overview = movie.overview {
                    Text(overview)
                        .font(.body)
                        .lineLimit(4)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 8)
    }
}
