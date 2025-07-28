import SwiftUI

@MainActor
class AppCoordinator: ObservableObject {
    
    enum ActiveScreen: Hashable {
        case movieDetail(movieId: Int)
        case reviews(reviews: [Review])
        case moviesByKeyword(keyword: Keyword)
        case castList(cast: [PersonDisplayModel])
        case crewList(crew: [PersonDisplayModel])
        case similarMovies(movies: [Movie])
        case recommendedMovies(movies: [Movie])
        case personDetail(personId: Int)
    }
    
    enum DisplayMode {
        case verticalList
        case horizontalList
    }

    @Published var path: [ActiveScreen] = []
    @Published var selectedCategory: MovieCategory = .nowPlaying
    @Published var displayMode: DisplayMode = .verticalList
    
    func toggleDisplayMode() {
        displayMode = (displayMode == .verticalList) ? .horizontalList : .verticalList
    }
    
    func selectCategory(_ category: MovieCategory) {
        selectedCategory = category
    }
    
    func showMovieDetail(movieId: Int) {
        path.append(.movieDetail(movieId: movieId))
    }
    
    func showReviews(_ reviews: [Review]) {
        path.append(.reviews(reviews: reviews))
    }
    
    func showMoviesByKeyword(keyword: Keyword) {
        path.append(.moviesByKeyword(keyword: keyword))
    }
    
    func showCastList(_ cast: [PersonDisplayModel]) {
        path.append(.castList(cast: cast))
    }
    
    func showCrewList(_ crew: [PersonDisplayModel]) {
        path.append(.crewList(crew: crew))
    }
    
    func showSimilarMovies(_ movies: [Movie]) {
        path.append(.similarMovies(movies: movies))
    }
    
    func showRecommendedMovies(_ movies: [Movie]) {
        path.append(.recommendedMovies(movies: movies))
    }
    
    func showPersonDetail(personId: Int) {
        path.append(.personDetail(personId: personId))
    }

    func closeLastScreen() {
        _ = path.popLast()
    }

    func resetToRoot() {
        path = []
    }
}
