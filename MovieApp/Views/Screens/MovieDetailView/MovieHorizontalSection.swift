import SwiftUI

struct MovieHorizontalSection: View {
    let title: String
    let movies: [Movie]
    let onSeeAllTapped: () -> Void
    let onMovieTapped: (Movie) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Button("See All") {
                    onSeeAllTapped()
                }
                .font(.subheadline)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(movies) { movie in
                        Button(action: {
                            onMovieTapped(movie)
                        }) {
                            MoviePreviewCell(movie: movie)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

