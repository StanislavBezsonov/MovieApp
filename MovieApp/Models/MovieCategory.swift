import Foundation

enum MovieCategory: String, CaseIterable, Identifiable {
    case nowPlaying = "Now Playing"
    case topRated = "Top Rated"
    case upcoming = "Upcoming"
    case popular = "Popular"
    case trending = "Trending"
    
    var id: String { rawValue }    
}
