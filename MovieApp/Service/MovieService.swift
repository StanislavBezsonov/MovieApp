import Foundation

// MARK: - Protocol

protocol MovieServiceProtocol {
    func fetchNowPlayingMovies() async throws -> [Movie]
    func fetchUpcomingMovies() async throws -> [Movie]
    func fetchPopularMovies() async throws -> [Movie]
    func fetchTopRatedMovies() async throws -> [Movie]
    func fetchTrendingMovies() async throws -> [Movie]
    func fetchGenres() async throws -> [Genre]
    func fetchPopularActors() async throws -> [Actor]
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
    static let language = "en-US"
    static let defaultPage = "1"
}

// MARK: - Response Models

private struct MovieResponse: Codable {
    let results: [Movie]
}

private struct GenresResponse: Codable {
    let genres: [Genre]
}

private struct PopularActorsResponse: Codable {
    let results: [Actor]
}

// MARK: - MovieService

final class MovieService: MovieServiceProtocol {
    
    static let shared = MovieService()
    private init() {}
   
    private func fetch<T: Decodable>(from endpoint: String, queryItems: [URLQueryItem] = []) async throws -> T {
        guard let url = makeURL(endpoint: endpoint, queryItems: queryItems) else {
            throw MovieServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MovieServiceError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON response from \(endpoint):\n\(jsonString)")
        }
        
        let decoder = JSONDecoder()

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw MovieServiceError.decodingFailed
        }
    }

    private func makeURL(endpoint: String, queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents(string: Endpoint.baseURL + endpoint)
        var allItems = [
            URLQueryItem(name: "api_key", value: Endpoint.apiKey),
            URLQueryItem(name: "language", value: Endpoint.language),
            URLQueryItem(name: "page", value: Endpoint.defaultPage)
        ]
        allItems.append(contentsOf: queryItems)
        components?.queryItems = allItems
        return components?.url
    }

    // MARK: - Public API Methods
    
    func fetchNowPlayingMovies() async throws -> [Movie] {
        let response: MovieResponse = try await fetch(from: "/movie/now_playing")
        return response.results
    }

    func fetchUpcomingMovies() async throws -> [Movie] {
        let response: MovieResponse = try await fetch(from: "/movie/upcoming")
        return response.results
    }

    func fetchPopularMovies() async throws -> [Movie] {
        let response: MovieResponse = try await fetch(from: "/movie/popular")
        return response.results
    }

    func fetchTopRatedMovies() async throws -> [Movie] {
        let response: MovieResponse = try await fetch(from: "/movie/top_rated")
        return response.results
    }

    func fetchTrendingMovies() async throws -> [Movie] {
        let response: MovieResponse = try await fetch(from: "/trending/movie/week")
        return response.results
    }

    func fetchGenres() async throws -> [Genre] {
        let response: GenresResponse = try await fetch(from: "/genre/movie/list")
        return response.genres
    }

    func fetchPopularActors() async throws -> [Actor] {
        let response: PopularActorsResponse = try await fetch(from: "/person/popular")
        return response.results
    }
}
