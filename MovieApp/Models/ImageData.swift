import Foundation

struct ImageData: Equatable, Hashable, Identifiable {
    let filePath: String

    var url: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500\(filePath)")
    }
    
    var id: String { filePath }
    
    init(dto: ImageDataDTO) {
        self.filePath = dto.filePath
    }
}
