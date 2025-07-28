import Foundation
import Combine

@MainActor
class MoviesCategoriesViewModel: ObservableObject {
    @Published var selectedCategory: MovieCategory = .allCases.first!
    
    weak var coordinator: AppCoordinator?
    
    init(coordinator: AppCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    func selectCategory(_ category: MovieCategory) {
        selectedCategory = category
    }
}
