import SwiftUI

struct MoviesCategoriesView: View {
    @StateObject private var viewModel: MoviesCategoriesViewModel

    init(coordinator: AppCoordinator) {
        _viewModel = StateObject(wrappedValue: MoviesCategoriesViewModel(coordinator: coordinator))
    }

    var body: some View {
        
        TabView(selection: $viewModel.selectedCategory) {
            ForEach(MovieCategory.allCases, id: \.self) { category in
                MoviesListView(category: category, coordinator: viewModel.coordinator)
                    .tag(category)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .accentColor(.red)
        .navigationTitle(viewModel.selectedCategory.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}
