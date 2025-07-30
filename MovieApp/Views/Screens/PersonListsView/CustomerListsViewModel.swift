import Foundation
import Combine

@MainActor
final class CustomerListsViewModel: ObservableObject {
    @Published var movies: [Movie] = []

    let userMovieList = UserMoviesManager.shared
    private let movieService: MovieServiceProtocol
    weak var coordinator: AppCoordinator?

    init(movieService: MovieServiceProtocol, coordinator: AppCoordinator?) {
        self.movieService = movieService
        self.coordinator = coordinator
    }

    func movieTapped (_ movie: Movie) {
        coordinator?.showMovieDetail(movieId: movie.id)
    }

    func onViewAppeared() {
        Task {
            await loadWishlistMovies()
        }
    }

    private func loadWishlistMovies() async {
        var result: [Movie] = []

        for id in userMovieList.wishlist {
            do {
                let movie = try await movieService.fetchMovieByID(id)
                result.append(movie)
            } catch {
                print("Error \(id): \(error)")
            }
        }

        self.movies = result
    }
}
