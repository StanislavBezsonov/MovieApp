struct Country: Equatable {
    let code: String
    let name: String
    
    init(dto: CountryDTO) {
        self.code = dto.iso31661
        self.name = dto.name
    }
}
