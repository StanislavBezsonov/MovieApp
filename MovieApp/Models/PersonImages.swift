import Foundation

struct PersonImages: Equatable, Hashable, Identifiable {
    let id = UUID()
    let profiles: [ImageData]
}


