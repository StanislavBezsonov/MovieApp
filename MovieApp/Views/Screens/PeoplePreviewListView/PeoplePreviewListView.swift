import SwiftUI

struct PeoplePreviewListView: View {
    @StateObject private var viewModel: PeoplePreviewListViewModel

    init(title: String, people: [PersonDisplayModel], coordinator: AppCoordinator? = nil) {
        _viewModel = StateObject(wrappedValue: PeoplePreviewListViewModel(title: title, people: people, coordinator: coordinator))
    }

    var body: some View {
        List(viewModel.people) { person in
            PersonRowCell(details: person)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.personTapped(person)
                }
        }
        .navigationTitle(viewModel.title)
        .listStyle(.plain)
    }
}
