import Foundation

struct Person: Identifiable, Equatable, Hashable  {
    let id: Int
    let name: String
    let imagePath: String?
    let movieTitles: [String]?

    init(dto: PersonDTO) {
        self.id = dto.id
        self.name = dto.name
        self.imagePath = dto.profilePath
        self.movieTitles = dto.knownFor?.compactMap { $0.title ?? $0.name }
    }
    
    var imageURL: URL? {
        guard let imagePath = imagePath, !imagePath.isEmpty else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)")
    }
}
