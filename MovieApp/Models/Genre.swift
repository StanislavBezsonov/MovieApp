struct Genre: Identifiable, Equatable {
    let id: Int
    let name: String
    
    init(dto: GenreDTO){
        id = dto.id
        name = dto.name
    }
}
