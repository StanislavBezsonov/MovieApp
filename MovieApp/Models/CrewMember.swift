import Foundation

struct CrewMember: Identifiable, Equatable {
    let id: Int
    let name: String
    let job: String?
    let department: String?
    let profilePath: String?
    
    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
    
    init(dto: CrewMemberDTO) {
        self.id = dto.id
        self.name = dto.name
        self.job = dto.job
        self.department = dto.department
        self.profilePath = dto.profilePath
    }
}
