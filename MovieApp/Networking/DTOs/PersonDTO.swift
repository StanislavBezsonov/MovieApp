struct PersonDTO: Codable {
    let id: Int
    let name: String
    let profilePath: String?
    let knownFor: [KnownForDTO]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
}

struct KnownForDTO: Codable {
    let title: String?
    let name: String?
    
    var displayTitle: String? {
        title ?? name
    }
}
