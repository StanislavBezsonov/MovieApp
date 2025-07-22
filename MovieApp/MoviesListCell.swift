import SwiftUI

struct MovieListCell: View {
    let movie: Movie
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let posterPath = movie.posterPath,
                           let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 100, height: 150)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 150)
                                        .clipped()
                                        .cornerRadius(8)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 150)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 150)
                                .foregroundColor(.gray)
                        }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if let date = movie.releaseDate {
                    Text(date)
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
