import Foundation

struct PersonDetail: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let birthday: Date?
    let deathday: Date?
    let imagePath: String?
    let bio: String?
    let popularity: Double?
    let department: String?
    let placeOfBirth: String?
    let movies: [MovieDTO]?
    let profileImages: PersonImages?
    
    var age: Int? {
        guard let birthday = birthday else { return nil }
        
        let calendar = Calendar.current
        let now = Date()
        
        let endDate = deathday ?? now
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: endDate)
        return ageComponents.year
    }
    
    init(dto: PersonDTO,
         profileImages: PersonImages? = nil
    ) {
        self.id = dto.id
        self.name = dto.name
        self.birthday = Self.date(from: dto.birthday)
        self.deathday = Self.date(from: dto.deathday)
        self.imagePath = dto.imagePath
        self.bio = dto.bio
        self.popularity = dto.popularity
        self.department = dto.department
        self.placeOfBirth = dto.placeOfBirth
        self.movies = dto.movies
        self.profileImages = profileImages
    }
    
    var imageURL: URL? {
        guard let imagePath = imagePath, !imagePath.isEmpty else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)")
    }
    
    // MARK: - Helpers

    private static func date(from string: String?) -> Date? {
        guard let string = string else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }
    
    var birthdayFormatted: String? {
        guard let date = birthday else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var deathdayFormatted: String? {
        guard let date = deathday else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
