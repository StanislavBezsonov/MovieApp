final class UserMoviesManager {
    static let shared = UserMoviesManager()

    private(set) var wishlist: [Int] = []
    private(set) var seenlist: [Int] = []

    private init() {}

    func addToWishlist(_ movieId: Int) {
        if !wishlist.contains(movieId) {
            wishlist.append(movieId)
        }
    }

    func addToSeenlist(_ movieId: Int) {
        if !seenlist.contains(movieId) {
            seenlist.append(movieId)
        }
    }
}
