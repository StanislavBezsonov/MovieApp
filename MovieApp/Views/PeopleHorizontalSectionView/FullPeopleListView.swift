import SwiftUI

struct FullPeopleListView: View {
    let title: String
    let people: [PersonDisplayModel]

    var body: some View {
        List(people) { person in
            PersonRowCell(
                imageURL: person.imageURL,
                name: person.name,
                subtitle: person.subtitle
            )
        }
        .navigationTitle(title)
    }
}
