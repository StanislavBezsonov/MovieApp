import SwiftUI

struct PeopleHorizontalSection: View {
    let title: String
    let people: [PersonDisplayModel]
    let onSeeAllTapped: () -> Void
    let onPersonTapped: (PersonDisplayModel) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Button("See all") {
                    onSeeAllTapped()
                }
                .font(.subheadline)                
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(people) { person in
                        Button(action: {
                            onPersonTapped(person)
                        }) {
                            PersonCell(details: person)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}
