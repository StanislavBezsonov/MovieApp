import SwiftUI

struct MoviesListView: View {
    @StateObject private var viewModel: MoviesListViewModel

    init(category: MovieCategory, movieService: MovieServiceProtocol = Current.movieService) {
        _viewModel = StateObject(wrappedValue: MoviesListViewModel(category: category, movieService: movieService))
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    CustomSearchBar(searchText: $viewModel.searchText).listRowInsets(EdgeInsets())
                        ForEach(viewModel.filteredMovies) { movie in
                            NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                MovieListCell(viewModel: MovieListCellModel(movie: movie))
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
}
