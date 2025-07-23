import Foundation

struct AppEnvironment {
    var movieService: MovieServiceProtocol
    var mainQueue: DispatchQueue
}

var Current = AppEnvironment(
    movieService: MovieService.live,
    mainQueue: .main
)
