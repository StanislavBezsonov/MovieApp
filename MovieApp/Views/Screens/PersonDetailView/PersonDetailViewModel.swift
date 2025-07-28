import Combine
import Foundation

@MainActor
final class PersonDetailViewModel: ObservableObject {
    @Published var personDetail: PersonDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var movies: [Movie] = []
    
    private let personId: Int
    private let movieService: MovieServiceProtocol
    weak var coordinator: AppCoordinator?
    
    var moviesByYear: [(year: String, movies: [Movie])] {
        groupMoviesByYear(movies)
    }
    
    var title: String {
        personDetail?.name ?? "Person"
    }
    
    init(personId: Int, movieService: MovieServiceProtocol, coordinator: AppCoordinator?) {
        self.personId = personId
        self.movieService = movieService
        self.coordinator = coordinator
    }
    
    func onViewAppear() {
        Task {
            await loadPersonDetails()
        }
    }
    
    private func loadPersonDetails() async {
        isLoading = true
        defer { isLoading = false }
        
        async let dto = movieService.fetchPersonByIdRaw(personId)
        async let images = movieService.fetchPersonImages(personId: personId)
        async let moviesList = movieService.fetchMovieCredits(forPersonId: personId)
        
        do {
            let (personDTO, personImages, movieCredits) = try await (dto, images, moviesList)
            personDetail = PersonDetail(dto: personDTO, profileImages: personImages)
            movies = movieCredits
        } catch {
            errorMessage = "Failed to load person details: \(error.localizedDescription)"
        }
    }
    
    func onMovieTapped(_ movie: Movie) {
        coordinator?.showMovieDetail(movieId: movie.id)
    }
    
    func groupMoviesByYear(_ movies: [Movie]) -> [(year: String, movies: [Movie])] {
        let currentYear = Calendar.current.component(.year, from: Date())

        let filteredMovies = movies.compactMap { movie -> (year: Int, movie: Movie)? in
            guard
                let dateString = movie.releaseDate,
                let yearString = dateString.prefix(4) as Substring?,
                let year = Int(yearString),
                year > 0
            else { return nil }
            return (year, movie)
        }

        let upcomingMovies = filteredMovies.filter { $0.year > currentYear }.map { $0.movie }
        let pastMovies = filteredMovies.filter { $0.year <= currentYear }

        let grouped = Dictionary(grouping: pastMovies) { $0.year }

        let sortedYears = grouped.keys.sorted(by: >)

        var result: [(year: String, movies: [Movie])] = []

        if !upcomingMovies.isEmpty {
            result.append((year: "Upcoming", movies: upcomingMovies))
        }

        for year in sortedYears {
            if let movies = grouped[year]?.map(\.movie) {
                result.append((year: "\(year)", movies: movies))
            }
        }

        return result
    }
}

