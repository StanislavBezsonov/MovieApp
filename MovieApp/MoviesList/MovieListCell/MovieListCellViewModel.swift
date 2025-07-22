import Foundation

class MovieListCellViewModel: ObservableObject, Identifiable {
    private let movie: Movie
    
    var id: Int { movie.id }
    var title: String { movie.title }
    var overview: String {
        movie.overview ?? "N/A"
    }
    
    var posterURL: URL? {
        guard let path = movie.posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200/\(path)")
    }
    
    var formattedReleaseDate: String {
        guard let releaseDate = movie.releaseDate else { return "Unknown date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: releaseDate) {
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        }
        return "N/A"
    }
    
    var voteAverage: String {
        if let vote = movie.voteAverage {
            return String(format: "%.1f", vote)
        } else {
            return "N/A"
        }
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}
