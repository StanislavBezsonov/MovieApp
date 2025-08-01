import Foundation
import Combine

@MainActor
final class CustomerListsViewModel: ObservableObject {
    @Published var selectedList: CustomerListType = .wishlist
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let userMoviesList: UserMoviesStorage
    private let movieService: MovieServiceProtocol
    weak var coordinator: AppCoordinator?

    init(movieService: MovieServiceProtocol, userMovieList: UserMoviesStorage = UserMoviesStorage(), coordinator: AppCoordinator?) {
        self.movieService = movieService
        self.userMoviesList = userMovieList
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
        isLoading = true
        defer { isLoading = false }

        let saved = userMoviesList.getMovies(for: list)

        var result: [Movie] = []

        await withTaskGroup(of: Movie?.self) { group in
            for savedMovie in saved {
                group.addTask {
                    do {
                        return try await self.movieService.fetchMovieByID(Int(savedMovie.id))
                    } catch {
                        print("Failed to load \(savedMovie.id): \(error)")
                        return nil
                    }
                }
            }

            for await movie in group {
                if let movie = movie {
                    result.append(movie)
                }
            }
        }

        self.movies = result
    }
}

