import Foundation

@MainActor
final class DiscoverMovieViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var movies: [Movie] = []
    @Published var topCardOffset: CGSize = .zero
    @Published var sortBy: String = "popularity.desc"
    @Published var releaseYear: Int
    @Published var selectedGenre: Genre? = nil
    @Published var genres: [Genre] = []

    private let movieService: MovieServiceProtocol
    private let storage: UserMoviesStorage
    private let coordinator: AppCoordinator?
    private let ignoredStorage: IgnoredMoviesStorage
    private var currentPage = 1
    private var allPagesLoaded = false
    
    init(movieService: MovieServiceProtocol, storage: UserMoviesStorage, ignoredStorage: IgnoredMoviesStorage, coordinator: AppCoordinator?) {
        self.movieService = movieService
        self.storage = storage
        self.ignoredStorage = ignoredStorage
        self.coordinator = coordinator
        self.releaseYear = DiscoverMovieViewModel.startOfDecade(for: Calendar.current.component(.year, from: Date()))
    }
    
    static func startOfDecade(for year: Int) -> Int {
        return (year / 10) * 10
    }
    
    func onViewAppeared() {
        Task {
            await loadMovies()
        }
    }
    
    func onSheetAppeared() {
        Task {
            await loadGenres()
        }
    }
    
    func onFilterChanged() {
        Task {
            await loadMovies(reset: true)
        }
    }
    
    private func loadGenres() async {
        do {
            genres = try await movieService.fetchGenres()
        } catch {
            print("Failed to load genres: \(error.localizedDescription)")
        }
    }
    
    func loadMovies(reset: Bool = false) async {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }

        if reset {
            currentPage = 1
            allPagesLoaded = false
            movies.removeAll()
        }

        while !allPagesLoaded {
            var queryItems: [URLQueryItem] = [
                URLQueryItem(name: "sort_by", value: sortBy),
                URLQueryItem(name: "primary_release_date.gte", value: "\(releaseYear)-01-01"),
                URLQueryItem(name: "primary_release_date.lte", value: "\(releaseYear + 9)-12-31"),
                URLQueryItem(name: "page", value: "\(currentPage)")
            ]

            if let genre = selectedGenre {
                queryItems.append(URLQueryItem(name: "with_genres", value: "\(genre.id)"))
            }

            do {
                let fetchedMovies = try await movieService.discoverMovies(queryItems: queryItems)
                let ignoredIDs = Set(ignoredStorage.getAllIgnoredMovies().map { Int($0.id) })
                let filteredMovies = fetchedMovies.filter { !ignoredIDs.contains($0.id) }

                if filteredMovies.isEmpty {
                    if fetchedMovies.isEmpty {
                        allPagesLoaded = true
                        break
                    } else {
                        currentPage += 1
                        continue
                    }
                } else {
                    movies.append(contentsOf: filteredMovies)
                    currentPage += 1
                    break
                }
            } catch {
                errorMessage = "Failed to load movies: \(error.localizedDescription)"
                break
            }
        }
    }

    
    func indexForDecade(from year: Int, in decades: [String]) -> Int? {
        let decade = (year / 10) * 10
        return decades.firstIndex(of: "\(decade)s")
    }
    
    func randomizeFilters(from decades: [String]) -> Int? {
        let sortOptions = ["popularity.desc", "vote_average.desc", "release_date.desc"]
        sortBy = sortOptions.randomElement() ?? "popularity.desc"

        var updatedDecadeIndex: Int? = nil

        if let randomDecade = decades.randomElement() {
            let yearString = randomDecade.replacingOccurrences(of: "s", with: "")
            if let year = Int(yearString) {
                releaseYear = DiscoverMovieViewModel.startOfDecade(for: year)
                updatedDecadeIndex = decades.firstIndex(of: randomDecade)
            }
        }

        selectedGenre = genres.randomElement()

        return updatedDecadeIndex
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
        ignoredStorage.addIgnoredMovie(movie.id)

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
        
        if movies.count <= 2 && !allPagesLoaded {
            Task {
                await loadMovies()
            }
        }
    }
    
    func updateSwipeOffset(_ offset: CGSize) {
        topCardOffset = offset
    }

    func resetSwipeOffset() {
        topCardOffset = .zero
    }
}


