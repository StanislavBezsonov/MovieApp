import SwiftUI

struct DiscoverFilterView: View {
    @ObservedObject var viewModel: DiscoverMovieViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedDecadeIndex: Int = 0
    
    private var decades: [String] {
        Array(stride(from: 2020, through: 1950, by: -10)).map { "\($0)s" }
    }
    
    var body: some View {
        Form {
            Section {
                Picker("Sort by", selection: $viewModel.sortBy) {
                    Text("Popularity").tag("popularity.desc")
                    Text("Rating").tag("vote_average.desc")
                    Text("Release Date").tag("release_date.desc")
                }
                
                Picker("Release Decade", selection: $selectedDecadeIndex) {
                    ForEach(decades.indices, id: \.self) { index in
                        Text(decades[index]).tag(index)
                    }
                }
                .onChange(of: selectedDecadeIndex) { newIndex in
                    let yearString = decades[newIndex].replacingOccurrences(of: "s", with: "")
                    if let year = Int(yearString) {
                        viewModel.releaseYear = year
                    }
                }
                
                if !viewModel.genres.isEmpty {
                    Picker("Genre", selection: $viewModel.selectedGenre) {
                        Text("Any").tag(Genre?.none)
                        ForEach(viewModel.genres, id: \.id) { genre in
                            Text(genre.name).tag(Genre?.some(genre))
                        }
                    }
                }
            }
            
            Section {
                Button("Save and filter movies") {
                    viewModel.onFilterChanged()
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .tint(.green)

                Button("Randomize filters", role: .destructive) {
                    if let index = viewModel.randomizeFilters(from: decades) {
                        selectedDecadeIndex = index
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            viewModel.onSheetAppeared()
            selectedDecadeIndex = viewModel.indexForDecade(from: viewModel.releaseYear, in: decades) ?? 0

        }
    }
}
