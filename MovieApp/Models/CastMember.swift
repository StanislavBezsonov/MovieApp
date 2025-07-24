import Foundation

struct CastMember: Identifiable, Equatable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?
    
    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
    
    init(dto: CastMemberDTO) {
        self.id = dto.id
        self.name = dto.name
        self.character = dto.character
        self.profilePath = dto.profilePath
    }
}
