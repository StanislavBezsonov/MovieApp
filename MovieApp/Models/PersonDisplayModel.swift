import SwiftUI

struct PersonDisplayModel: Identifiable, Equatable, Hashable {
    let personId: Int
    let imageURL: URL?
    let name: String
    let subtitle: String?
    
    var id: String {
        if let subtitle = subtitle {
            return "\(personId)-\(subtitle)"
        } else {
            return "\(personId)"
        }
    }
}
