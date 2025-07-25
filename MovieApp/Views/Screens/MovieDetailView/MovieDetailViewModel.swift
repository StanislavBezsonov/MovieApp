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

extension MovieDetail {
    var hasReviews: Bool {
        return reviews?.isEmpty == false
    }
    var reviewsCountText: String {
        return "Reviews: \(reviews?.count ?? 0)"
    }
    var hasSimilarMovies: Bool {
        return similarMovies?.isEmpty == false
    }
    var hasRecommendedMovies: Bool {
        return recommendedMovies?.isEmpty == false
    }
    var hasPosters: Bool {
        return images?.posters.isEmpty == false
    }
    var hasBackdrops: Bool {
        return images?.backdrops.isEmpty == false
    }
    
    var director: CrewMember? {
        return crew?.first(where: { $0.job == "Director" })
    }
}
