struct PersonDTO: Codable {
    let id: Int
    let name: String
    let birthday: String?
    let deathday: String?
    let imagePath: String?
    let bio: String?
    let popularity: Double?
    let department: String?
    let placeOfBirth: String?
    let additionalImagesPaths: [String]?
    let movies: [MovieDTO]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case birthday
        case deathday
        case imagePath = "profile_path"
        case bio = "biography"
        case popularity
        case department = "known_for_department"
        case placeOfBirth = "place_of_birth"
        case additionalImagesPaths = "additional_images_paths"
        case movies
    }
}
