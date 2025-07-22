import SwiftUI

@MainActor
class AppCoordinator: ObservableObject {
    enum DisplayMode {
        case verticalList
        case horizontalList
    }

    @Published var selectedCategory: MovieCategory = .nowPlaying
    @Published var displayMode: DisplayMode = .verticalList
    @Published var selectedMovie: Movie? = nil
    @Published var isShowingSettings: Bool = false
    
    func toggleDisplayMode() {
        displayMode = (displayMode == .verticalList) ? .horizontalList : .verticalList
    }
    
    func selectCategory(_ category: MovieCategory) {
        selectedCategory = category
    }
    
    func showDetails(for movie: Movie) {
        selectedMovie = movie
    }
    
    func closeDetails() {
        selectedMovie = nil
    }
    
    func showSettings() {
        isShowingSettings = true
    }
    
    func closeSettings() {
        isShowingSettings = false
    }
}
