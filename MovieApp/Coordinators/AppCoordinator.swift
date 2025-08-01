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

    @Published var categoriesPath = NavigationPath()
    @Published var discoverPath = NavigationPath()
    @Published var fanClubPath = NavigationPath()
    @Published var userListsPath = NavigationPath()
    @Published var path: [ActiveScreen] = []
    @Published var selectedCategory: MovieCategory = .nowPlaying
    @Published var displayMode: DisplayMode = .verticalList
    @Published var selectedTab: Tab = .categories {
        didSet {
            resetInactivePaths()
        }
    }
    var currentPath: Binding<NavigationPath> {
        switch selectedTab {
        case .categories:
            return Binding(get: { self.categoriesPath }, set: { self.categoriesPath = $0 })
        case .discover:
            return Binding(get: { self.discoverPath }, set: { self.discoverPath = $0 })
        case .fanClub:
            return Binding(get: { self.fanClubPath }, set: { self.fanClubPath = $0 })
        case .userLists:
            return Binding(get: { self.userListsPath }, set: { self.userListsPath = $0 })
        }
    }
    
    func toggleDisplayMode() {
        displayMode = (displayMode == .verticalList) ? .horizontalList : .verticalList
    }
    
    func showCategory(_ category: MovieCategory) {
        selectedCategory = category
        displayMode = .verticalList
    }
    
    func selectCategory(_ category: MovieCategory) {
        selectedCategory = category
    }
    
    func showMovieDetail(movieId: Int) {
        currentPath.wrappedValue.append(ActiveScreen.movieDetail(movieId: movieId))
    }

    func showReviews(_ reviews: [Review]) {
        currentPath.wrappedValue.append(ActiveScreen.reviews(reviews: reviews))
    }

    func showMoviesByKeyword(keyword: Keyword) {
        currentPath.wrappedValue.append(ActiveScreen.moviesByKeyword(keyword: keyword))
    }

    func showCastList(_ cast: [PersonDisplayModel]) {
        currentPath.wrappedValue.append(ActiveScreen.castList(cast: cast))
    }

    func showCrewList(_ crew: [PersonDisplayModel]) {
        currentPath.wrappedValue.append(ActiveScreen.crewList(crew: crew))
    }

    func showSimilarMovies(_ movies: [Movie]) {
        currentPath.wrappedValue.append(ActiveScreen.similarMovies(movies: movies))
    }

    func showRecommendedMovies(_ movies: [Movie]) {
        currentPath.wrappedValue.append(ActiveScreen.recommendedMovies(movies: movies))
    }

    func showPersonDetail(personId: Int) {
        currentPath.wrappedValue.append(ActiveScreen.personDetail(personId: personId))
    }

    func destinationView(for screen: ActiveScreen) -> some View {
        switch screen {
        case .movieDetail(let movieId):
            AnyView(MovieDetailView(movieId: movieId, coordinator: self))
        case .reviews(let reviews):
            AnyView(ReviewsView(reviews: reviews))
        case .moviesByKeyword(let keyword):
            AnyView(KeywordSearchResultsView(keyword: keyword, coordinator: self))
        case .similarMovies(let movies):
            AnyView(MoviePreviewListView(title: "Similar Movies", movies: movies, coordinator: self))
        case .recommendedMovies(let movies):
            AnyView(MoviePreviewListView(title: "Recommended Movies", movies: movies, coordinator: self))
        case .castList(let cast):
            AnyView(PeoplePreviewListView(title: "Cast", people: cast, coordinator: self))
        case .crewList(let crew):
            AnyView(PeoplePreviewListView(title: "Crew", people: crew, coordinator: self))
        case .personDetail(let personId):
            AnyView(PersonDetailView(personId: personId, coordinator: self))
        }
    }
    
    private func resetInactivePaths() {
        if selectedTab != .categories {
            categoriesPath = NavigationPath()
        }
        if selectedTab != .discover {
            discoverPath = NavigationPath()
        }
        if selectedTab != .fanClub {
            fanClubPath = NavigationPath()
        }
        if selectedTab != .userLists {
            userListsPath = NavigationPath()
        }
    }
}

extension AppCoordinator {
    
    enum DisplayMode {
        case verticalList
        case horizontalList
    }
    
    enum Tab: Hashable {
        case categories
        case discover
        case fanClub
        case userLists
    }
}
