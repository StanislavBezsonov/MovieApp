import SwiftUI

struct MovieDetailView: View {
    let movieId: Int
    
    @StateObject private var viewModel: MovieDetailViewModel
    
    init(movieId: Int, movieService: MovieServiceProtocol = Current.movieService) {
        self.movieId = movieId
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId, movieService: movieService))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if let details = viewModel.movieDetail {
                List {
                    MovieDetailCell(movie: details)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    MovieActionCell()
                    
                    if let overview = viewModel.movieDetail?.overview {
                        OverviewCell(overview: overview)
                    }
                        
                    Section {
                        if let keywords = details.keywords {
                            KeywordsCell(keywords: keywords)
                        }
                    }
                }
                .navigationTitle(details.title)
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .onAppear {
            viewModel.onViewAppeared()
        }
    }
}
