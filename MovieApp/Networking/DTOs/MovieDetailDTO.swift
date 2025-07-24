struct MovieDetailDTO: Codable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let runtime: Int?
    let status: String?
    let genres: [GenreDTO]
    let productionCountries: [CountryDTO]

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, status, genres
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case productionCountries = "production_countries"
    }
}
