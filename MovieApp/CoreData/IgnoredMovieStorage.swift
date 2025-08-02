import CoreData

final class IgnoredMoviesStorage {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }

    func getAllIgnoredMovies() -> [IgnoredMovie] {
        let request: NSFetchRequest<IgnoredMovie> = IgnoredMovie.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch ignored movies: \(error)")
            return []
        }
    }

    func addIgnoredMovie(_ id: Int) {
        guard !isMovieIgnored(id) else { return }

        let movie = IgnoredMovie(context: context)
        movie.id = Int64(id)
        saveContext()
    }

    func removeIgnoredMovie(_ id: Int) {
        let request: NSFetchRequest<IgnoredMovie> = IgnoredMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)

        do {
            let moviesToDelete = try context.fetch(request)
            for movie in moviesToDelete {
                context.delete(movie)
            }
            saveContext()
        } catch {
            print("Failed to delete ignored movie: \(error)")
        }
    }

    func isMovieIgnored(_ id: Int) -> Bool {
        let request: NSFetchRequest<IgnoredMovie> = IgnoredMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1

        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Failed to check ignored movie: \(error)")
            return false
        }
    }

    func clearAllIgnoredMovies() {
        let request: NSFetchRequest<NSFetchRequestResult> = IgnoredMovie.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to clear ignored movies: \(error)")
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
