import SwiftUI

struct MoviesListView: View {
    @StateObject private var viewModel: MoviesListViewModel
    
    init(category: MovieCategory, movieService: MovieServiceProtocol = Current.movieService, coordinator: AppCoordinator? = nil) {
        _viewModel = StateObject(wrappedValue: MoviesListViewModel(category: category, movieService: movieService, coordinator: coordinator))
    }
    
    var body: some View {
        VStack {
            List {
                CustomSearchBar(searchText: $viewModel.searchText).listRowInsets(EdgeInsets())
                ForEach(viewModel.filteredMovies) { movie in
                    MovieListCell(
                        viewModel: MovieListCellModel(
                            movie: movie,                                                                onMoviePressed: {                                                                    viewModel.movieTapped(movie)
                            }
                        )
                    )
                    .contentShape(Rectangle())
                    
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
