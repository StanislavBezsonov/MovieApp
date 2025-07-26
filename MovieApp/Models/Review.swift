struct Review: Identifiable, Equatable, Hashable {
    let id: String
    let author: String
    let content: String

    init(dto: ReviewDTO) {
        self.id = dto.id
        self.author = dto.author
        self.content = dto.content
    }
}
