import Foundation
import Combine

@MainActor
final class CustomerListsViewModel: ObservableObject {
    @Published var selectedList: CustomerListType = .wishlist
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
            await loadMovies(for: selectedList)
        }
    }
    
    func onListChanged(_ newList: CustomerListType) {
        Task {
            await loadMovies(for: newList)
        }
    }

    private func loadMovies(for list: CustomerListType) async {
        let saved = userMovieList.getMovies(for: list)
        var result: [Movie] = []

        for savedMovie in saved {
            do {
                let movie = try await movieService.fetchMovieByID(Int(savedMovie.id))
                result.append(movie)
            } catch {
                print("Failed to fetch movie \(savedMovie.id): \(error)")
            }
        }

        self.movies = result
    }
}
