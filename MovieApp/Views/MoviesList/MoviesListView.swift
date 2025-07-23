import SwiftUI

struct MoviesListView: View {
    @StateObject private var viewModel: MoviesListViewModel

    init(category: MovieCategory, movieService: MovieServiceProtocol = Current.movieService) {
        _viewModel = StateObject(wrappedValue: MoviesListViewModel(category: category, movieService: movieService))
    }

    var body: some View {
        VStack {
            List {
                Section(header: CustomSearchBar(searchText: $viewModel.searchText)) {
                    ForEach(viewModel.filteredMovies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieListCell(viewModel: MovieListCellViewModel(movie: movie))
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
        .onAppear {
            viewModel.onViewAppeared()
        }
    }
}
