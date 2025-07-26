import SwiftUI

struct PersonDisplayModel: Identifiable, Equatable, Hashable {
    let id = UUID()
    let imageURL: URL?
    let name: String
    let subtitle: String?
}
