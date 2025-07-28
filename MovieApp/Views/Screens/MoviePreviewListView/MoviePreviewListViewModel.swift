import Foundation

@MainActor
final class MoviePreviewListViewModel: ObservableObject {
    let title: String
    let movies: [Movie]
    weak var coordinator: AppCoordinator?

    init(title: String, movies: [Movie], coordinator: AppCoordinator? = nil) {
        self.title = title
        self.movies = movies
        self.coordinator = coordinator
    }

    func movieTapped(_ movie: Movie) {
        coordinator?.showMovieDetail(movieId: movie.id)
    }
}
