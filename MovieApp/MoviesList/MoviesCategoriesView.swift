import SwiftUI

struct MoviesCategoriesView: View {
    @State private var selectedCategory: MovieCategory = .allCases.first!
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedCategory) {
                ForEach(MovieCategory.allCases, id: \.self) { category in
                    MoviesListView(category: category)
                        .tag(category)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .navigationTitle(selectedCategory.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("First button tapped")
                    }) {
                        Image(systemName: "plus")
                    }
                    
                    Button(action: {
                        print("Second button tapped")
                    }) {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
    }
}
