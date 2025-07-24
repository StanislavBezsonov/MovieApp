struct MovieResponse: Codable {
    let results: [MovieDTO]
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



