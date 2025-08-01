import CoreData

final class FavoritePersonStorage {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }

    func isStarred(personId: Int) -> Bool {
        let request: NSFetchRequest<FavoritePerson> = FavoritePerson.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", personId)
        request.fetchLimit = 1

        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking starred person: \(error)")
            return false
        }
    }

    func addStarred(personId: Int) {
        guard !isStarred(personId: personId) else { return }

        let starredPerson = FavoritePerson(context: context)
        starredPerson.id = Int64(personId)

        saveContext()
    }

    func removeStarred(personId: Int) {
        let request: NSFetchRequest<FavoritePerson> = FavoritePerson.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", personId)

        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("Error removing starred person: \(error)")
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func fetchAllStarredIds() -> [Int] {
        let request: NSFetchRequest<FavoritePerson> = FavoritePerson.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            return results.map { Int($0.id) }
        } catch {
            print("Error fetching starred ids: \(error)")
            return []
        }
    }
}
