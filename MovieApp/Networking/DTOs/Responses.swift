struct MovieResponse: Codable {
    let results: [MovieDTO]
}

struct PersonsResponse: Codable {
    let results: [PersonDTO]
}

struct GenresResponse: Codable {
    let genres: [GenreDTO]
}

struct KeywordsResponse: Codable {
    let keywords: [KeywordDTO]
}

struct CreditsResponse: Codable {
    let cast: [CastMemberDTO]
    let crew: [CrewMemberDTO]
}

struct ReviewsResponse: Codable {
    let results: [ReviewDTO]
}



