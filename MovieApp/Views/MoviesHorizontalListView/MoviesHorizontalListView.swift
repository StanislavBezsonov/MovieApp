import SwiftUI

struct MoviesHorizontalListView: View {

    var body: some View {
        List {
            ForEach(MovieCategory.allCases) { category in
                MovieHorizontalListCell(
                    category: category,
                    onSeeAll: {
                        print("Tapped See All for \(category.rawValue)")
                    }
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.plain)
        .navigationTitle(Text("Movies"));
    }
}
