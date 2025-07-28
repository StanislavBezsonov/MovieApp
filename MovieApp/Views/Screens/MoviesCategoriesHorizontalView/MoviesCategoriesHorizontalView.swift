import SwiftUI

struct MoviesCategoriesHorizontalView: View {
    @StateObject private var viewModel: MoviesCategoriesHorizontalViewModel
    
    init(movieService: MovieServiceProtocol = Current.movieService, coordinator: AppCoordinator? = nil) {
        _viewModel = StateObject(wrappedValue: MoviesCategoriesHorizontalViewModel(movieService: movieService, coordinator: coordinator))
    }

    var body: some View {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()

                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(MovieCategory.allCases) { category in
                            MovieHorizontalListCell(
                                category: category,
                                onSeeAll: {
                                    print("Tapped See All for \(category.rawValue)")
                                }
                            )
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Movies")
        }
}

