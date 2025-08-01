import CoreData

final class UserMoviesStorage {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }

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
    
    func addMovie(_ id: Int, to listType: CustomerListType) {
        let existing = getMovies(for: listType).first { $0.id == id }
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
    
    func isMovie(_ id: Int, in listType: CustomerListType) -> Bool {
        let request: NSFetchRequest<SavedMovie> = SavedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d AND listType == %@", id, listType.rawValue)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Failed to check movie in \(listType): \(error)")
            return false
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
