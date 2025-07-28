import Foundation
import Combine

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let movieId: Int
    private let movieService: MovieServiceProtocol
    weak var coordinator: AppCoordinator? = nil

    init(movieId: Int, movieService: MovieServiceProtocol, coordinator: AppCoordinator?) {
        self.movieId = movieId
        self.movieService = movieService
        self.coordinator = coordinator
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
        } catch {
            errorMessage = "Failed to load movie details: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Navigation actions
    
    func showReviewsTapped() {
        guard let reviews = movieDetail?.reviews else { return }
        coordinator?.showReviews(reviews)
    }
    
    func keywordTapped(_ keyword: Keyword) {
        coordinator?.showMoviesByKeyword(keyword: keyword)
    }

    func personTapped(_ person: PersonDisplayModel) {
        coordinator?.showPersonDetail(personId: person.personId)
    }
    
    func movieTapped(_ movie: Movie) {
        coordinator?.showMovieDetail(movieId: movie.id)
    }
    
    func seeAllCastTapped() {
        guard let cast = movieDetail?.cast else { return }
        let peopleModels = cast.map {
            PersonDisplayModel(personId: $0.id, imageURL: $0.profileURL, name: $0.name, subtitle: $0.character)
        }
        coordinator?.showCastList(peopleModels)
    }

    func seeAllCrewTapped() {
        guard let crew = movieDetail?.crew else { return }
        let peopleModels = crew.map {
            PersonDisplayModel(personId: $0.id, imageURL: $0.profileURL, name: $0.name, subtitle: $0.job)
        }
        coordinator?.showCastList(peopleModels)
    }
    
    func seeAllSimilarTapped() {
        guard let similar = movieDetail?.similarMovies else { return }
        if let coordinator = coordinator {
            coordinator.showSimilarMovies(similar)
        }
    }
    
    func seeAllRecommendedTapped() {
        guard let recommended = movieDetail?.recommendedMovies else { return }
        if let coordinator = coordinator {
            coordinator.showRecommendedMovies(recommended)
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
