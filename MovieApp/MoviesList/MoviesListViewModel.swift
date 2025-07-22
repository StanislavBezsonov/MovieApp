import Foundation
import Combine

@MainActor
final class MoviesListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
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
        errorMessage = nil
        do {
            movies = try await MovieService.shared.fetchNowPlayingMovies()
        } catch {
            errorMessage = "Failed to load movies: \(error.localizedDescription)"
        }
        isLoading = false
    }
}


