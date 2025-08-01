import SwiftUI

struct CustomerListsView: View {
    @StateObject private var viewModel: CustomerListsViewModel
    
    init(coordinator: AppCoordinator? = nil, movieService: MovieServiceProtocol = Current.movieService) {
        _viewModel = StateObject(wrappedValue: CustomerListsViewModel(movieService: movieService, coordinator: coordinator))
    }
    
    var body: some View {
        VStack {
            Picker("Select list", selection: $viewModel.selectedList) {
                ForEach(CustomerListType.allCases, id:\.self) { list in
                    Text(list.title).tag(list)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: viewModel.selectedList) { newValue in
                viewModel.onListChanged(newValue)
            }
            
            List {
                ForEach(viewModel.movies) { movie in
                    MovieListCell(
                        viewModel: MovieListCellModel(
                            movie: movie,
                            onMoviePressed: {                                                  viewModel.movieTapped(movie)
                            }
                        )
                    )
                    .contentShape(Rectangle())
                }
            }
            .listStyle(.plain)
        }
        .onAppear {
            viewModel.onViewAppeared()
        }
    }
    
}
