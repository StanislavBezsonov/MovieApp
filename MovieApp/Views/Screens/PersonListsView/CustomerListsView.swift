import SwiftUI

struct CustomerListsView: View {
    @StateObject private var viewModel: CustomerListsViewModel

    init(coordinator: AppCoordinator? = nil, movieService: MovieServiceProtocol = Current.movieService) {
        _viewModel = StateObject(wrappedValue: CustomerListsViewModel(movieService: movieService, coordinator: coordinator))
    }

    var body: some View {
        List {
            ForEach(viewModel.movies) { movie in
                MovieListCell(
                    viewModel: MovieListCellModel(
                        movie: movie,
                        onMoviePressed: {                                                                    viewModel.movieTapped(movie)
                            }
                    )
                )                .contentShape(Rectangle())
            }
        }
        .onAppear {
            viewModel.onViewAppeared()
        }
    }
}
