import Foundation
import Combine

@MainActor
final class MoviesCategoriesHorizontalViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let movieService: MovieServiceProtocol
    weak var coordinator: AppCoordinator?
   
    init(movieService: MovieServiceProtocol, coordinator: AppCoordinator? = nil) {
        self.movieService = movieService
        self.coordinator = coordinator
    }
    
    func movieTapped (_ movie: Movie) {
        coordinator?.showMovieDetail(movieId: movie.id)
    }
}


