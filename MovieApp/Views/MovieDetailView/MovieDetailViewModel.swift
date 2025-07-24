import Foundation
import Combine

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let movieId: Int
    private let movieService: MovieServiceProtocol
    
    init(movieId: Int, movieService: MovieServiceProtocol) {
        self.movieId = movieId
        self.movieService = movieService
    }
    
    func onViewAppeared() {
        Task {
            await loadMovieDetails()
        }
    }
    
    private func loadMovieDetails() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            movieDetail = try await movieService.fetchMovieDetail(id: movieId)
        }
        catch {
            errorMessage = "Failed to load movie details: \(error.localizedDescription)"
        }
    }
}
