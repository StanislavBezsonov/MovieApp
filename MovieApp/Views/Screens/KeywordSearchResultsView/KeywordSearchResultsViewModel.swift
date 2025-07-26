import Foundation

@MainActor
class KeywordSearchResultsViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let keyword: Keyword
    private let movieService: MovieServiceProtocol

    init(keyword: Keyword, movieService: MovieServiceProtocol = Current.movieService) {
        self.keyword = keyword
        self.movieService = movieService
    }

    func loadMovies() async {
        isLoading = true
        defer { isLoading = false }

        do {
            movies = try await movieService.fetchMoviesByKeyword(keyword.id)
        } catch {
            errorMessage = "Failed to load movies for \(keyword.name): \(error.localizedDescription)"
        }
    }
}
