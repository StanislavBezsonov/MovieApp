import SwiftUI

struct MoviesCategoriesHorizontalView: View {
    @StateObject private var viewModel = MoviesCategoriesHorizontalViewModel()
    
    init(coordinator: AppCoordinator? = nil) {
        _viewModel = StateObject(wrappedValue: MoviesCategoriesHorizontalViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        List {
            ForEach(MovieCategory.allCases) { category in
                MovieHorizontalListCell(
                    category: category,
                    movies: viewModel.moviesByCategory[category] ?? [],
                    onSeeAll: {
                        viewModel.seeAllTapped(category)
                    },
                    onTapMovie: { movie in
                        viewModel.movieTapped(movie)
                    }
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
        }
        .navigationTitle("Categories")
        .listStyle(.plain)
        .onAppear {
            viewModel.onViewAppeared()
        }
    }
}
