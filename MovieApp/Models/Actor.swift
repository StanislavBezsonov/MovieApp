struct Actor: Identifiable {
    let id: Int
    let name: String
    let profilePath: String?
    let popularity: Double
    
    init(dto: ActorDTO) {
        self.id = dto.id
        self.name = dto.name
        self.profilePath = dto.profilePath
        self.popularity = dto.popularity        
    }
}
