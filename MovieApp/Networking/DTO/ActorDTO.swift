struct ActorDTO: Codable {
    let id: Int
    let name: String
    let profilePath: String?
    let popularity: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
        case popularity
    }
}
