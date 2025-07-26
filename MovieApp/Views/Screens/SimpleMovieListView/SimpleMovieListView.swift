import SwiftUI

struct SimpleMovieListView: View {
    let title: String
    let movies: [Movie]

    var body: some View {
        List(movies) { movie in
            MovieListCell(viewModel: MovieListCellModel(movie: movie))            
        }
        .navigationTitle(title)
        .listStyle(PlainListStyle())
    }
}
