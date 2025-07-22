import Foundation

@MainActor
class MovieHorizontalListCellViewModel: ObservableObject, Identifiable {
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
            let result = try await MovieService.shared.fetchMovies(for: category)
            self.movies = result
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
