import SwiftUI

struct KeywordSearchResultsView: View {
    let keyword: Keyword
    @StateObject private var viewModel: KeywordSearchResultsViewModel

    init(keyword: Keyword, coordinator: AppCoordinator? = nil) {
        self.keyword = keyword
        _viewModel = StateObject(wrappedValue: KeywordSearchResultsViewModel(keyword: keyword, coordinator: coordinator))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List(viewModel.movies) { movie in
                    MovieListCell(
                        viewModel: MovieListCellModel(
                            movie: movie,
                            onMoviePressed: { [weak viewModel] in
                                viewModel?.movieTapped(movie)
                            }
                        )
                    )
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle(keyword.name)
        .onAppear {
            viewModel.onViewAppeared()
        }
    }
}
