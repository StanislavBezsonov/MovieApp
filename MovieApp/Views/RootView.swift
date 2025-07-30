import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.path) {
                VStack(spacing: 0) {
                    switch coordinator.displayMode {
                    case .verticalList:
                        MoviesCategoriesView(coordinator: coordinator)
                    case .horizontalList:
                        MoviesCategoriesHorizontalView(coordinator: coordinator)
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
                        MovieDetailView(movieId: movieId, coordinator: coordinator)
                    case .reviews(let reviews):
                        ReviewsView(reviews: reviews)
                    case .moviesByKeyword(let keyword):
                        KeywordSearchResultsView(keyword: keyword, coordinator: coordinator)
                    case .similarMovies(let movies):
                        MoviePreviewListView(title: "Similar Movies", movies: movies, coordinator: coordinator)
                    case .recommendedMovies(let movies):
                        MoviePreviewListView(title: "Recommended Movies", movies: movies, coordinator: coordinator)
                    case .castList(let cast):
                        PeoplePreviewListView(title: "Cast", people: cast, coordinator: coordinator)
                    case .crewList(let crew):
                        PeoplePreviewListView(title: "Crew", people: crew, coordinator: coordinator)
                    case .personDetail(let personId):
                        PersonDetailView(personId: personId, coordinator: coordinator)
                    }
                }
            }
            .tabItem {
                Label("Categories", systemImage: "film")
            }
            .tag(AppCoordinator.Tab.categories)
            
            NavigationStack {
                CustomerListsView(coordinator: coordinator)
                    .navigationTitle("My Lists")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Wishlist", systemImage: "heart")
            }
            .tag(AppCoordinator.Tab.userLists)
        }
    }
}

