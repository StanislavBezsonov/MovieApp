import SwiftUI

struct MovieDetailView: View {
    let movieId: Int
    
    @StateObject private var viewModel: MovieDetailViewModel
    
    init(movieId: Int, movieService: MovieServiceProtocol = Current.movieService) {
        self.movieId = movieId
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId, movieService: movieService))
    }

    var body: some View {
        VStack {
            List {
                if let details = viewModel.movieDetail {
                    Text(details.title)                    
                }
            }
        }
    }
}


struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movieId: 1)
    }
}


