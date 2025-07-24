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
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
}

extension MovieDTO {
    static var mock: MovieDTO {
        MovieDTO(
            id: 1,
            title: "The Matrix",
            overview: "A computer hacker learns about the true nature of reality and his role in the war against its controllers.",
            posterPath: "/matrix.jpg",
            releaseDate: "1999-03-31",
            voteAverage: 8.7
        )
    }
}

extension Movie {
    static var mock: Movie {
        Movie(dto: MovieDTO.mock)
    }
}
