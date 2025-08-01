import Foundation

@MainActor
final class FanClubViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var fanClub: [Person] = []
    @Published var favoritePersons: [Person] = []

    private let favoriteStorage = FavoritePersonStorage()
    private let movieService: MovieServiceProtocol
    private let coordinator: AppCoordinator?
    
    init(movieService: MovieServiceProtocol, coordinator: AppCoordinator?) {
        self.movieService = movieService
        self.coordinator = coordinator
    }
    
    func onViewAppeared() {
        Task {
            await loadFavoritePersons()
            await loadFanClub()
        }
    }
    
    func loadFavoritePersons() async {
        let starredIds = favoriteStorage.fetchAllStarredIds()
        guard !starredIds.isEmpty else {
            favoritePersons = []
            return
        }
        
        var loadedPersons: [Person] = []
        for id in starredIds {
            do {
                let person = try await movieService.fetchPersonById(id)
                loadedPersons.append(person)
            } catch {
                print("Failed to load person \(id): \(error)")
            }
        }
        
        favoritePersons = loadedPersons
    }
    
    func personTapped(_ person: Person) {
        coordinator?.showPersonDetail(personId: person.id)
    }
    
    private func loadFanClub() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let allPopularPersons = try await movieService.fetchPopularPersons()            
            let favoriteIds = Set(favoritePersons.map { $0.id })
            fanClub = allPopularPersons.filter { !favoriteIds.contains($0.id) }
        } catch {
            errorMessage = "Failed to load fan club. \(error.localizedDescription)"
        }
    }
}

