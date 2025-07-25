struct ReviewDTO: Codable, Identifiable {
    let id: String
    let author: String
    let content: String
}
