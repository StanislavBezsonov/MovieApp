import Foundation
import Combine

@MainActor
final class MoviesHorizontalListViewModel: ObservableObject {
    let category: MovieCategory
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
   
    init(category: MovieCategory) {
        self.category = category
        Task {
            await loadMovies()
        }
    }
    
    func loadMovies() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            movies = try await MovieService.shared.fetchMovies(for: category)
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load movies: \(error.localizedDescription)"
        }
    }
}


