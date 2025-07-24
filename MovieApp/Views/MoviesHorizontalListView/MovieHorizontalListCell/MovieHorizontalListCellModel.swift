import Foundation

@MainActor
class MovieHorizontalListCellModel: ObservableObject, Identifiable {
    let category: MovieCategory
    private let movieService: MovieServiceProtocol
    
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init(category: MovieCategory, movieService: MovieServiceProtocol) {
        self.category = category
        self.movieService = movieService
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
            let result = try await movieService.fetchMovies(for: category)
            self.movies = result
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
