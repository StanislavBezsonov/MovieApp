import Foundation

// MARK: - Protocol

protocol MovieServiceProtocol {
    func fetchNowPlayingMovies() async throws -> [Movie]
    func fetchUpcomingMovies() async throws -> [Movie]
    func fetchPopularMovies() async throws -> [Movie]
    func fetchTopRatedMovies() async throws -> [Movie]
    func fetchTrendingMovies() async throws -> [Movie]
    func fetchMovies(for category: MovieCategory) async throws -> [Movie]
    func fetchGenres() async throws -> [Genre]
    func fetchMovieByID(_ id: Int) async throws -> Movie
    func fetchMovieDetail(id: Int) async throws -> MovieDetail
    func fetchMoviesByKeyword(_ keywordId: Int) async throws -> [Movie]
    func fetchPersonImages(personId: Int) async throws -> PersonImages
    func fetchMovieCredits(forPersonId id: Int) async throws -> [Movie]
    func fetchPersonByIdRaw(_ id: Int) async throws -> PersonDetailDTO
    func fetchPersonById(_ id: Int) async throws -> Person
    func fetchPopularPersons() async throws -> [Person]
    func discoverMovies(queryItems: [URLQueryItem]) async throws -> [Movie]
}

// MARK: - Custom Errors

enum MovieServiceError: Error {
    case invalidURL
    case serverError(statusCode: Int)
    case decodingFailed
}

// MARK: - API Constants

private enum Endpoint {
    static let apiKey = ProcessInfo.processInfo.environment["TMDB_API_KEY"] ?? ""
    static let baseURL = "https://api.themoviedb.org/3"
    static let language = "en_US"
    static let defaultPage = "1"
}

// MARK: - MovieService

final class MovieService: MovieServiceProtocol {
    
    init() {}
    
    private func fetch<T: Decodable>(from endpoint: String, as type: T.Type = T.self, queryItems: [URLQueryItem] = [],     includeDefaultQueryItems: Bool = true) async throws -> T {
        guard let url = makeURL(endpoint: endpoint, queryItems: queryItems, includeDefaultQueryItems: includeDefaultQueryItems) else {
            throw MovieServiceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MovieServiceError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw MovieServiceError.decodingFailed
        }
    }
    
    private func makeURL(endpoint: String, queryItems: [URLQueryItem], includeDefaultQueryItems: Bool = true) -> URL? {
        var components = URLComponents(string: Endpoint.baseURL + endpoint)
        var allItems: [URLQueryItem] = []
            
        if includeDefaultQueryItems {
            allItems = [
                URLQueryItem(name: "api_key", value: Endpoint.apiKey),
                URLQueryItem(name: "language", value: Endpoint.language),
                URLQueryItem(name: "page", value: Endpoint.defaultPage)
            ]
        } else {
            allItems = [
                URLQueryItem(name: "api_key", value: Endpoint.apiKey)
            ]
        }
        
        allItems.append(contentsOf: queryItems)
        components?.queryItems = allItems
        return components?.url
    }
    
    // MARK: - Public API Methods
    
    func fetchMovies(for category: MovieCategory) async throws -> [Movie] {
        switch category {
        case .nowPlaying:
            return try await fetchNowPlayingMovies()
        case .upcoming:
            return try await fetchUpcomingMovies()
        case .popular:
            return try await fetchPopularMovies()
        case .topRated:
            return try await fetchTopRatedMovies()
        case .trending:
            return try await fetchTrendingMovies()
        }
    }
    
    func fetchNowPlayingMovies() async throws -> [Movie] {
        let response: MovieResponse = try await fetch(from: "/movie/now_playing")
        let movies = response.results.map { Movie(dto: $0) }
        return movies
    }
    
    func fetchUpcomingMovies() async throws -> [Movie] {
        let response: MovieResponse = try await fetch(from: "/movie/upcoming")
        let movies = response.results.map { Movie(dto: $0) }
        return movies
    }
    
    func fetchPopularMovies() async throws -> [Movie] {
        let response: MovieResponse = try await fetch(from: "/movie/popular")
        let movies = response.results.map { Movie(dto: $0) }
        return movies
    }
    
    func fetchTopRatedMovies() async throws -> [Movie] {
        let response: MovieResponse = try await fetch(from: "/movie/top_rated")
        let movies = response.results.map { Movie(dto: $0) }
        return movies
    }
    
    func fetchTrendingMovies() async throws -> [Movie] {
        let response: MovieResponse = try await fetch(from: "/trending/movie/week")
        let movies = response.results.map { Movie(dto: $0) }
        return movies
    }
    
    func fetchGenres() async throws -> [Genre] {
        let response: GenresResponse = try await fetch(from: "/genre/movie/list")
        let genres = response.genres.map { Genre(dto: $0) }
        return genres
    }
    
    func fetchMovieByID(_ id: Int) async throws -> Movie {
        let dto: MovieDTO = try await fetch(from: "/movie/\(id)")
        return Movie(dto: dto)
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        async let detailDTO = fetch(from: "/movie/\(id)", as: MovieDetailDTO.self)
        async let keywordsDTO = fetch(from: "/movie/\(id)/keywords", as: KeywordsResponse.self)
        async let creditsDTO = fetch(from: "/movie/\(id)/credits", as: CreditsResponse.self)
        async let similarDTO = fetch(from: "/movie/\(id)/similar", as: MovieResponse.self)
        async let recommendedDTO = fetch(from: "/movie/\(id)/recommendations", as: MovieResponse.self)
        
        let queryItems = [URLQueryItem(name: "include_image_language", value: "en,null")]
        let imagesDTO = try await fetch(from: "/movie/\(id)/images", as: MovieImagesDTO.self, queryItems: queryItems, includeDefaultQueryItems: false)
                                        
        async let reviewsDTO = fetch(from: "/movie/\(id)/reviews", as: ReviewsResponse.self)
        
        let (detail, keywords, credits, similar, recommended, images, reviews) = try await (detailDTO, keywordsDTO, creditsDTO, similarDTO, recommendedDTO, imagesDTO, reviewsDTO)

        return MovieDetail(
            dto: detail,
            keywords: keywords.keywords.isEmpty ? nil : keywords.keywords.map { Keyword(dto: $0) },
            cast: credits.cast.isEmpty ? nil : credits.cast.map { CastMember(dto: $0) },
            crew: credits.crew.isEmpty ? nil : credits.crew.map { CrewMember(dto: $0) },
            similarMovies: similar.results.isEmpty ? nil : similar.results.map { Movie(dto: $0) },
            recommendedMovies: recommended.results.isEmpty ? nil : recommended.results.map { Movie(dto: $0) },
            images: (images.posters.isEmpty && images.backdrops.isEmpty) ? nil : MovieImages(
                posters: images.posters.map { ImageData(dto: $0) },
                backdrops: images.backdrops.map { ImageData(dto: $0) }
            ),
            reviews: reviews.results.isEmpty ? nil : reviews.results.map { Review(dto: $0) }
        )
    }
    
    func fetchMoviesByKeyword(_ keywordId: Int) async throws -> [Movie] {
        let queryItems = [
            URLQueryItem(name: "with_keywords", value: String(keywordId)),
            URLQueryItem(name: "sort_by", value: "popularity.desc")
        ]
        let response: MovieResponse = try await fetch(from: "/discover/movie", queryItems: queryItems)
        let movies = response.results.map { Movie(dto: $0) }
        return movies
    }
    
    func fetchPersonByIdRaw(_ id: Int) async throws -> PersonDetailDTO {
        return try await fetch(from: "/person/\(id)")
    }
    
    func fetchPersonById(_ id: Int) async throws -> Person {
        let dto: PersonDTO = try await fetch(from: "/person/\(id)")
        return Person(dto: dto)
    }
    
    func fetchPersonImages(personId: Int) async throws -> PersonImages {
        let dto: PersonImagesDTO = try await fetch(from: "/person/\(personId)/images")
        let profiles = dto.profiles.map { ImageData(dto: $0) }
        return PersonImages(profiles: profiles)
    }
    
    func fetchMovieCredits(forPersonId id: Int) async throws -> [Movie] {
        let creditsDTO: PersonMovieCreditsDTO = try await fetch(from: "/person/\(id)/movie_credits")
        let castMovies = creditsDTO.cast
        let crewMovies = creditsDTO.crew
        let allMoviesDTO = castMovies + crewMovies

        var uniqueMoviesDict = [Int: Movie]()
        for dto in allMoviesDTO {
            let movie = Movie(dto: dto)
            uniqueMoviesDict[movie.id] = movie
        }

        return Array(uniqueMoviesDict.values)
    }
    
    func fetchPopularPersons() async throws -> [Person] {
        let response: PersonsResponse = try await fetch(from: "/person/popular")
        return response.results.map { Person(dto: $0) }
    }
    
    func discoverMovies(queryItems: [URLQueryItem] = []) async throws -> [Movie] {
        let response: MovieResponse = try await fetch(from: "/discover/movie", queryItems: queryItems)
        return response.results.map { Movie(dto: $0) }
    }
}
