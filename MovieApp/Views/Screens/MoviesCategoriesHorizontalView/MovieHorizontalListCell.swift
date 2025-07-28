import SwiftUI

struct MovieHorizontalListCell: View {
    let category: MovieCategory
    let movies: [Movie]
    let onSeeAll: () -> Void
    let onTapMovie: (Movie) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(category.rawValue.capitalized)
                    .font(.title2)
                    .bold()
                Spacer()
                Button("See all", action: onSeeAll)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)

            if movies.isEmpty {
                Text("No movies available")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(movies) { movie in
                            MoviePosterCell(movie: movie)
                                .onTapGesture {
                                    onTapMovie(movie)
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.vertical, 6)
    }
}
