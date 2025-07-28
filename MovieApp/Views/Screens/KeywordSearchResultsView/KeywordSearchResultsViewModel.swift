import Foundation

@MainActor
class KeywordSearchResultsViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let keyword: Keyword
    private let movieService: MovieServiceProtocol
    weak var coordinator: AppCoordinator? = nil

    init(keyword: Keyword, movieService: MovieServiceProtocol = Current.movieService, coordinator: AppCoordinator? = nil) {
        self.keyword = keyword
        self.movieService = movieService
        self.coordinator = coordinator
    }

    func onViewAppeared() {
        Task {
            await loadMovies()
        }
    }
    
    private func loadMovies() async {
        isLoading = true
        defer { isLoading = false }

        do {
            movies = try await movieService.fetchMoviesByKeyword(keyword.id)
        } catch {
            errorMessage = "Failed to load movies for \(keyword.name): \(error.localizedDescription)"
        }
    }
    
    func movieTapped(_ movie: Movie) {
        coordinator?.showMovieDetail(movieId: movie.id)
    }
}
