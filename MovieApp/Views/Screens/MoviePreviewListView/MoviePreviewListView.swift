import SwiftUI

struct MoviePreviewListView: View {
    @StateObject private var viewModel: MoviePreviewListViewModel

    init(title: String, movies: [Movie], coordinator: AppCoordinator? = nil) {
        _viewModel = StateObject(wrappedValue: MoviePreviewListViewModel(title: title, movies: movies, coordinator: coordinator))
    }

    var body: some View {
        List(viewModel.movies) { movie in
            MovieListCell(
                viewModel: MovieListCellModel(
                    movie: movie,
                    onMoviePressed: {
                        viewModel.movieTapped(movie)
                    }
                )
            )
        }
        .navigationTitle(viewModel.title)
        .listStyle(PlainListStyle())
    }
}
