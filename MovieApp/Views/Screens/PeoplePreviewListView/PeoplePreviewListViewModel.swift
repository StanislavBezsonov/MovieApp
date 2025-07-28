import Foundation

@MainActor
final class PeoplePreviewListViewModel: ObservableObject {
    let title: String
    let people: [PersonDisplayModel]
    weak var coordinator: AppCoordinator?

    init(title: String, people: [PersonDisplayModel], coordinator: AppCoordinator? = nil) {
        self.title = title
        self.people = people
        self.coordinator = coordinator
    }

    func personTapped(_ person: PersonDisplayModel) {
        coordinator?.showPersonDetail(personId: person.personId)
    }
}
