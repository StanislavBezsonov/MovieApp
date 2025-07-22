import Foundation
import Combine

@MainActor
final class MoviesListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    let category: MovieCategory
    
    init(category: MovieCategory) {
        self.category = category
    }
    
    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return movies
        }
        else {
            return movies.filter { $0.title.localizedStandardContains(searchText) }
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


