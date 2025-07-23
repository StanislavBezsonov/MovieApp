import Foundation
import Combine

@MainActor
final class MoviesHorizontalListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let category: MovieCategory
    let movieService: MovieServiceProtocol
   
    init(category: MovieCategory, movieService: MovieServiceProtocol) {
        self.category = category
        self.movieService = movieService
        Task {
            await loadMovies()
        }
    }
    
    func loadMovies() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            movies = try await movieService.fetchMovies(for: category)
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load movies: \(error.localizedDescription)"
        }
    }
}


