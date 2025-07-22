import SwiftUI

struct MovieHorizontalListCell: View {
    @StateObject var viewModel: MovieHorizontalListCellViewModel
    let onSeeAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(viewModel.category.rawValue)
                    .font(.title2)
                    .bold()
                Spacer()
                Button("See all", action: onSeeAll)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.movies) { movie in
                            MoviePosterView(movie: movie)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
