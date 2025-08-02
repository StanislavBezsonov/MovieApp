import SwiftUI

struct MovieDetailCell: View {
    let movie: MovieDetail
    
    private let posterWidth: CGFloat = 110
    private let posterHeight: CGFloat = 165
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 4) {
                if let url = movie.posterURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: posterWidth, height: posterHeight)
                                .clipped()
                                .cornerRadius(6)
                                .border(Color(.white), width: 2)
                                .padding(.trailing, 8)
                        case .failure(_):
                            placeholderImage
                        case .empty:
                            placeholderImage
                        @unknown default:
                            placeholderImage
                        }
                    }
                } else {
                    placeholderImage
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    HStack(alignment: .center, spacing: 6) {
                        if let releaseDate = movie.releaseDate {
                            Text(releaseDate.formatted(.dateTime.year()))
                        }
                        if let runtime = movie.runtime {
                            Text("• \(runtime) min")
                        }
                        if let status = movie.status {
                            Text("• \(status)")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.top, 14)
                    
                    if let country = movie.productionCountries?.first {
                        Text(country.name)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    
                    HStack(alignment: .center, spacing: 12) {
                        if let average = movie.voteAverage {
                            CircularRatingView(rating: average, textColor: .white)
                                .frame(width: 44, height: 44)
                        }
                        if let voteCount = movie.voteCount {
                            Text("\(voteCount) ratings")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            
            if let genres = movie.genres {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(genres) { genre in
                            Text(genre.name)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .cornerRadius(10)
                                .font(.caption)
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
        .padding()
        .background(
            ZStack {
                if let url = movie.posterURL {
                    AsyncImage(url: url) { phase in
                        if case .success(let image) = phase {
                            image
                                .resizable()
                                .scaledToFill()
                                .blur(radius: 40)
                                .overlay(Color.black.opacity(0.2))
                                .clipped()
                        }
                    }
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var placeholderImage: some View {
            ZStack {
                Color.gray.opacity(0.3)
                    .frame(width: posterWidth, height: posterHeight)
                    .cornerRadius(6)
                    .border(Color.white, width: 2)
                    .padding(.trailing, 8)
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
}
