import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack(spacing: 0) {
                switch coordinator.displayMode {
                case .verticalList:
                    MoviesCategoriesView()
                case .horizontalList:
                    MoviesHorizontalListView()
                }
            }
            .navigationTitle(coordinator.selectedCategory.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        coordinator.toggleDisplayMode()
                    } label: {
                        Image(systemName: coordinator.displayMode == .verticalList ? "square.grid.2x2" : "list.bullet")
                    }
                }
            }
            .navigationDestination(for: AppCoordinator.ActiveScreen.self) { screen in
                switch screen {
                case .movieDetail(let movieId):
                    MovieDetailView(movieId: movieId)
                case .reviews(let reviews):
                    ReviewsView(reviews: reviews)
                case .moviesByKeyword(let keyword):
                    KeywordSearchResultsView(keyword: keyword)
                case .similarMovies(let movies):
                    MoviePreviewListView(title: "Similar Movies", movies: movies)
                case .recommendedMovies(let movies):
                    MoviePreviewListView(title: "Recommended Movies", movies: movies)
                case .castList(let cast):
                    PeoplePreviewListView(title: "Cast", people: cast)
                case .crewList(let crew):
                    PeoplePreviewListView(title: "Crew", people: crew)
                case .personDetail(let personId):
                    PersonDetailView(personId: personId)

                }
            }
        }
    }
}

