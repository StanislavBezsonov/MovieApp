import Foundation

@MainActor
final class FanClubViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var fanClub: [Person] = []
    
    let title: String
    private let movieService: MovieServiceProtocol
    private let coordinator: AppCoordinator?
    
    init(title:String, movieService: MovieServiceProtocol, coordinator: AppCoordinator?) {
        self.title = title
        self.movieService = movieService
        self.coordinator = coordinator
    }
    
    func onViewAppeared() {
        Task {
            await loadFanClub()
        }
    }
    
    private func loadFanClub() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            fanClub = try await movieService.fetchPopularPersons()
        } catch {
            errorMessage = "Failed to load fan club. \(error.localizedDescription)"
        }
    }
}

