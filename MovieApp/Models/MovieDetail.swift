import Foundation

struct MovieDetail {
    let id: Int
    let title: String
    let overview: String?
    let posterURL: URL?
    let releaseDate: Date?
    let voteAverage: Double?
    let voteCount: Int?
    let runtime: Int?
    let status: String?
    let genres: [Genre]?
    let productionCountries: [Country]?
    let keywords: [Keyword]?
    let cast: [CastMember]?
    let crew: [CrewMember]?
    let reviews: [Review]?
    let similarMovies: [Movie]?
    let recommendedMovies: [Movie]?
    let images: MovieImages?

    init(
        dto: MovieDetailDTO,
        keywords: [Keyword]?,
        cast: [CastMember]?,
        crew: [CrewMember]?,
        similarMovies: [Movie]?,
        recommendedMovies: [Movie]?,
        images: MovieImages?,
        reviews: [Review]?
    ) {
        self.id = dto.id
        self.title = dto.title
        self.overview = dto.overview
        self.posterURL = dto.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0)") }
        self.releaseDate = dto.releaseDate.flatMap { DateHelper.date(from: $0) }
        self.voteAverage = dto.voteAverage
        self.voteCount = dto.voteCount
        self.runtime = dto.runtime
        self.status = dto.status
        self.genres = dto.genres.isEmpty ? nil : dto.genres.map { Genre(dto: $0) }
        self.productionCountries = dto.productionCountries.isEmpty ? nil : dto.productionCountries.map { Country(dto: $0) }
        self.keywords = keywords
        self.cast = cast
        self.crew = crew
        self.reviews = reviews
        self.similarMovies = similarMovies
        self.recommendedMovies = recommendedMovies
        self.images = images
    }
}

