import SwiftUI

struct MoviesListView: View {
    @State private var searchText = ""
    let movies = ["Inception", "Interstellar", "Dunkirk", "Tenet", "Memento"]
    
    var body: some View {
        TabView {
            NavigationView {
                VStack(spacing: 0) {
                    List(movies, id: \.self) { movie in
                        Text(movie)
                    }
                    .navigationTitle(Text("Movies"))
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
                    .searchable(text: $searchText)
                }
            }
        }
    }
}

struct MoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView()
    }
}
