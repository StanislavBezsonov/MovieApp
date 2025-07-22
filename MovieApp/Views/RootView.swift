import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        NavigationStack {
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
        }
    }
}
