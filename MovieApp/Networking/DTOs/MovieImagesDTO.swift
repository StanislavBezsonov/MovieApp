struct MovieImagesDTO: Codable {
    let posters: [ImageDataDTO]
    let backdrops: [ImageDataDTO]
}

struct ImageDataDTO: Codable {
    let filePath: String

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}
