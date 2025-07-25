import SwiftUI

struct MoviesCategoriesView: View {
    @State private var selectedCategory: MovieCategory = .allCases.first!
    
    var body: some View {
        TabView(selection: $selectedCategory) {
            ForEach(MovieCategory.allCases, id: \.self) { category in
                MoviesListView(category: category)
                    .tag(category)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .navigationTitle(selectedCategory.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}
