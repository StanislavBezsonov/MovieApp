import Foundation
import Combine

@MainActor
class MoviesCategoriesViewModel: ObservableObject {
    @Published var selectedCategory: MovieCategory {
        didSet {
            coordinator?.selectedCategory = selectedCategory
        }
    }
    
    weak var coordinator: AppCoordinator?
    
    init(coordinator: AppCoordinator? = nil) {
        self.coordinator = coordinator
        self._selectedCategory = .init(initialValue: coordinator?.selectedCategory ?? .nowPlaying)
    }
    
    func selectCategory(_ category: MovieCategory) {
        selectedCategory = category
    }
}
