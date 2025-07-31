import CoreData

final class UserMoviesManager {
    static let shared = UserMoviesManager()
    private let context = PersistenceController.shared.context

    func getMovies(for listType: CustomerListType) -> [SavedMovie] {
        let request: NSFetchRequest<SavedMovie> = SavedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "listType == %@", listType.rawValue)
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch \(listType): \(error)")
            return []
        }
    }
    
    func addMovie(_ id:Int, to listType: CustomerListType) {
        let existing = getMovies(for: listType).first {$0.id == id }
        if existing != nil { return }
        
        let movie = SavedMovie(context: context)
        movie.id = Int64(id)
        movie.listType = listType.rawValue
        saveContext()
    }
    
    func removeMovie(_ id: Int, from listType: CustomerListType) {
        let request: NSFetchRequest<SavedMovie> = SavedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d AND listType == %@", id, listType.rawValue)
        
        do {
            let moviesToDelete = try context.fetch(request)
            for movie in moviesToDelete {
                context.delete(movie)
            }
            saveContext()
        } catch {
            print("Failed to delete movie: \(error)")
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
