import SwiftUI

struct MovieHorizontalSectionView: View {
    let title: String
    let movies: [Movie]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(movies) { movie in
                        MoviePreviewCell(
                            posterURL: movie.posterURL,
                            title: movie.title,
                            rating: movie.voteAverage
                        )
                        .listRowInsets(EdgeInsets())
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }
}
