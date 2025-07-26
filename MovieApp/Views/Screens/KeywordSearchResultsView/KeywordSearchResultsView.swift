import SwiftUI

struct KeywordSearchResultsView: View {
    let keyword: Keyword
    @StateObject private var viewModel: KeywordSearchResultsViewModel

    init(keyword: Keyword) {
        self.keyword = keyword
        _viewModel = StateObject(wrappedValue: KeywordSearchResultsViewModel(keyword: keyword))
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
                    MovieListCell(viewModel: MovieListCellModel(movie: movie))
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle(keyword.name)
        .task {
            await viewModel.loadMovies()
        }
    }
}
