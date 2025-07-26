struct Keyword: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    
    init(dto: KeywordDTO) {
        self.id = dto.id
        self.name = dto.name
    }
}
