import SwiftUI

struct PeoplePreviewListView: View {
    let title: String
    let people: [PersonDisplayModel]

    var body: some View {
        List(people) { person in
            PersonRowCell(details: person)
        }
        .navigationTitle(title)
    }
}
