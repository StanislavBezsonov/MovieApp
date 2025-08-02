import Foundation

@MainActor
final class DiscoverMovieViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var movies: [Movie] = []
    @Published var topCardOffset: CGSize = .zero
    @Published var sortBy: String = "popularity.desc"
    @Published var releaseYear: Int = Calendar.current.component(.year, from: Date())

    private let movieService: MovieServiceProtocol
    private let storage: UserMoviesStorage
    private let coordinator: AppCoordinator?
    
    init(movieService: MovieServiceProtocol, storage: UserMoviesStorage, coordinator: AppCoordinator?) {
        self.movieService = movieService
        self.storage = storage
        self.coordinator = coordinator
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
            let query: [URLQueryItem] = [
                URLQueryItem(name: "sort_by", value: sortBy),
                URLQueryItem(name: "year", value: "\(releaseYear)")
            ]
            movies = try await movieService.discoverMovies(queryItems: query)
        } catch {
            errorMessage = "Failed to load movies \(error.localizedDescription)"
        }
    }
}

extension DiscoverMovieViewModel {
    struct SwipeMessage {
        let icon: String
        let text: String
        let opacity: Double
    }
    
    var swipeMessage: SwipeMessage? {
        if topCardOffset == .zero { return nil }
        
        let alpha: Double
        if abs(topCardOffset.height) > abs(topCardOffset.width) {
            alpha = min(abs(topCardOffset.height) / CGFloat(100), 1)
            if topCardOffset.height > 50 {
                return SwipeMessage(icon: "👎", text: "Not Interested", opacity: alpha)
            }
        } else {
            alpha = min(abs(topCardOffset.width) / CGFloat(100), 1)
            if topCardOffset.width > 0 {
                return SwipeMessage(icon: "⭐️", text: "Wishlist", opacity: alpha)
            } else if topCardOffset.width < 0 {
                return SwipeMessage(icon: "👁", text: "Seen", opacity: alpha)
            }
        }
        return nil
    }
    
    func cardOffset(for index: Int) -> CGFloat {
        switch index {
        case 0: return 0
        case 1: return -20
        case 2: return 20
        default: return 0
        }
    }
    
    func cardRotation(for index: Int) -> Double {
        switch index {
        case 0: return 0
        case 1: return -5
        case 2: return 5
        default: return 0
        }
    }
    
    func cardScale(for index: Int) -> CGFloat {
        1 - CGFloat(index) * 0.05
    }
}

// MARK: - Swipe Handling

extension DiscoverMovieViewModel {
    
    func handleSwipe(movie: Movie, direction: SwipeDirection) {
        movies.removeAll { $0.id == movie.id }
        resetSwipeOffset()

        switch direction {
        case .left:
            if !storage.isMovie(movie.id, in: .seenlist) {
                storage.addMovie(movie.id, to: .seenlist)
            }
        case .right:
            if !storage.isMovie(movie.id, in: .wishlist) {
                storage.addMovie(movie.id, to: .wishlist)
            }
        case .down:
            break
        }
    }
    
    func updateSwipeOffset(_ offset: CGSize) {
        topCardOffset = offset
    }

    func resetSwipeOffset() {
        topCardOffset = .zero
    }
}


