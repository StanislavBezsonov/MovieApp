import SwiftUI

struct MovieHorizontalSection: View {
    let title: String
    let movies: [Movie]
    let onSeeAllTapped: () -> Void

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
                        MoviePreviewCell(movie: movie)
                    }
                }
            }
        }
    }
}

