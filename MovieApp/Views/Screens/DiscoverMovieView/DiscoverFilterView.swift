import SwiftUI

struct DiscoverFilterView: View {
    @ObservedObject var viewModel: DiscoverMovieViewModel
    @Environment(\.dismiss) var dismiss
    
    private let decades = [
        "2020-2029",
        "2010-2019",
        "2000-2009",
        "1990-1999",
        "1980-1989",
        "1970-1979"
    ]
    
    @State private var selectedDecadeIndex: Int = 0
    
    var body: some View {
        Form {
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
            
            Button("Save and filter movies") {
                let selectedDecade = decades[selectedDecadeIndex]
                if let startYearString = selectedDecade.split(separator: "-").first,
                   let startYear = Int(startYearString) {
                    viewModel.releaseYear = startYear
                }
                Task {
                    viewModel.onViewAppeared()
                    dismiss()
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Settings")
        .onAppear {
            selectedDecadeIndex = indexForYear(viewModel.releaseYear)
        }
    }
    
    private func indexForYear(_ year: Int) -> Int {
        for (index, decade) in decades.enumerated() {
            let parts = decade.split(separator: "-")
            if let start = Int(parts[0]), let end = Int(parts[1]) {
                if year >= start && year <= end {
                    return index
                }
            }
        }
        return 0
    }
}
