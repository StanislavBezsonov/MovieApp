import Foundation

extension Array where Element == CastMember {
    func toPersonDisplayModels() -> [PersonDisplayModel] {
        self.map { PersonDisplayModel(personId: $0.id, imageURL: $0.profileURL, name: $0.name, subtitle: $0.character) }
    }
}

extension Array where Element == CrewMember {
    func toPersonDisplayModels() -> [PersonDisplayModel] {
        self.map { PersonDisplayModel(personId: $0.id, imageURL: $0.profileURL, name: $0.name, subtitle: $0.job) }
    }
}
