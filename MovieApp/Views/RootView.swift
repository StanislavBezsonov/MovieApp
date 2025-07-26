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
                case .similarMovies(let movies):
                    SimpleMovieListView(title: "Similar Movies", movies: movies)
                case .recommendedMovies(let movies):
                    SimpleMovieListView(title: "Recommended Movies", movies: movies)
                case .castList(let cast):
                    FullPeopleListView(title: "Cast", people: cast)
                case .crewList(let crew):
                    FullPeopleListView(title: "Crew", people: crew)
                }
            }
        }
    }
}

