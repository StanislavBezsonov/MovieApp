import SwiftUI

struct MoviesListView: View {
    @StateObject private var viewModel: MoviesListViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    
    init(category: MovieCategory, movieService: MovieServiceProtocol = Current.movieService) {
        _viewModel = StateObject(wrappedValue: MoviesListViewModel(category: category, movieService: movieService))
    }
    
    var body: some View {
        VStack {
            List {
                CustomSearchBar(searchText: $viewModel.searchText).listRowInsets(EdgeInsets())
                ForEach(viewModel.filteredMovies) { movie in
                    MovieListCell(viewModel: MovieListCellModel(movie: movie))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            coordinator.showMovieDetail(movieId: movie.id)
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
