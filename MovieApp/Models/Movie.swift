import Foundation

struct Movie: Identifiable, Equatable {
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
}
