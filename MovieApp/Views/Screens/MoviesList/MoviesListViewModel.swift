import Foundation
import Combine

@MainActor
final class MoviesListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    let category: MovieCategory
    private let movieService: MovieServiceProtocol
    
    init(category: MovieCategory, movieService: MovieServiceProtocol) {
        self.category = category
        self.movieService = movieService
    }
    
    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return movies
        }
        else {
            return movies.filter { $0.title.localizedStandardContains(searchText) }
        }
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
            movies = try await movieService.fetchMovies(for: category)
        } catch {
            errorMessage = "Failed to load movies: \(error.localizedDescription)"
        }
    }
}


