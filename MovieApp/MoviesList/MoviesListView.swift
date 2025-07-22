import SwiftUI

struct MoviesListView: View {
    @StateObject private var viewModel = MoviesListViewModel()
    
    var body: some View {
        TabView {
            NavigationView {
                    List(viewModel.filteredMovies) { movie in
                        MovieListCell(movie: movie)
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle(Text("Movies"))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button(action: {
                                print("First button tapped")
                            }) {
                                Image(systemName: "plus")
                            }
                            
                            Button(action: {
                                print("Second button tapped")
                            }) {
                                Image(systemName: "ellipsis")
                            }
                            }
                        }
                    .searchable(text: $viewModel.searchText)
                    .overlay {
                        if viewModel.isLoading {
                            ProgressView()
                        }
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                    .task {
                        await viewModel.loadMovies()
                    }
            }
        }
    }
}

struct MoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView()
    }
}
