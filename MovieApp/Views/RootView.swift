import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            
            // MARK: - Categories Tab
            NavigationStack(path: $coordinator.categoriesPath) {
                categoriesView
                    .navigationDestination(for: AppCoordinator.ActiveScreen.self) { screen in
                        coordinator.destinationView(for: screen)
                    }
            }
            .tabItem {
                Label("Categories", systemImage: "film")
            }
            .tag(AppCoordinator.Tab.categories)

            // MARK: - Discover Tab
            NavigationStack(path: $coordinator.discoverPath) {
                DiscoverMovieView(coordinator: coordinator)
                    .navigationTitle("Discover")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(for: AppCoordinator.ActiveScreen.self) { screen in
                        coordinator.destinationView(for: screen)
                    }
            }
            .tabItem {
                Label("Discover", systemImage: "play.square.stack.fill")
            }
            .tag(AppCoordinator.Tab.discover)

            // MARK: - Fan Club Tab
            NavigationStack(path: $coordinator.fanClubPath) {
                FanClubView(coordinator: coordinator)
                    .navigationTitle("Fan Club")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(for: AppCoordinator.ActiveScreen.self) { screen in
                        coordinator.destinationView(for: screen)
                    }
            }
            .tabItem {
                Label("Fan Club", systemImage: "star")
            }
            .tag(AppCoordinator.Tab.fanClub)

            // MARK: - User Lists Tab
            NavigationStack(path: $coordinator.userListsPath) {
                CustomerListsView(coordinator: coordinator)
                    .navigationTitle("My Lists")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(for: AppCoordinator.ActiveScreen.self) { screen in
                        coordinator.destinationView(for: screen)
                    }
            }
            .tabItem {
                Label("Wishlist", systemImage: "heart")
            }
            .tag(AppCoordinator.Tab.userLists)
        }
    }

    private var categoriesView: some View {
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
    }
}
