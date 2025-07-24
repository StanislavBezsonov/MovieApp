import Foundation

struct MovieImages {
    let posters: [ImageData]
    let backdrops: [ImageData]
}

struct ImageData: Equatable {
    let filePath: String

    var url: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500\(filePath)")
    }
    
    init(dto: ImageDataDTO) {
        self.filePath = dto.filePath
    }
}
