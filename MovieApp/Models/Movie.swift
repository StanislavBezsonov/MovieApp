import Foundation

struct Movie: Identifiable, Equatable, Hashable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    
    init(dto: MovieDTO) {
        self.id = dto.id
        self.title = dto.title
        self.overview = dto.overview
        self.posterPath = dto.posterPath
        self.releaseDate = dto.releaseDate
        self.voteAverage = dto.voteAverage
    }
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
}
