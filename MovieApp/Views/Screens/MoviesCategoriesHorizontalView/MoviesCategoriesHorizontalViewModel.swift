import Foundation

@MainActor
final class MoviesCategoriesHorizontalViewModel: ObservableObject {
    @Published private(set) var moviesByCategory: [MovieCategory: [Movie]] = [:]
    @Published private(set) var isLoadingByCategory: [MovieCategory: Bool] = [:]
    @Published private(set) var errorMessageByCategory: [MovieCategory: String?] = [:]

    let movieService: MovieServiceProtocol
    weak var coordinator: AppCoordinator?

    init(movieService: MovieServiceProtocol = Current.movieService, coordinator: AppCoordinator? = nil) {
        self.movieService = movieService
        self.coordinator = coordinator
    }

    func onViewAppeared() {
        Task {
            for category in MovieCategory.allCases {
                await loadMovies(for: category)
            }
        }
    }

    private func loadMovies(for category: MovieCategory) async {
        isLoadingByCategory[category] = true
        defer { isLoadingByCategory[category] = false }

        do {
            let result = try await movieService.fetchMovies(for: category)
            moviesByCategory[category] = result
            errorMessageByCategory[category] = nil
        } catch {
            errorMessageByCategory[category] = error.localizedDescription
            moviesByCategory[category] = []
        }
    }
    
    func movieTapped(_ movie: Movie) {
        coordinator?.showMovieDetail(movieId: movie.id)
    }
    
    func seeAllTapped(_ category: MovieCategory) {
        coordinator?.showCategory(category)
    }
}
