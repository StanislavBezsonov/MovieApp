struct PersonMovieCreditsDTO: Decodable {
    let cast: [MovieDTO]
    let crew: [MovieDTO]
}
