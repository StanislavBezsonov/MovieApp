enum CustomerListType: String, CaseIterable {
    case wishlist
    case seenlist

    var title: String {
        switch self {
        case .wishlist: return "Wishlist"
        case .seenlist: return "Seenlist"
        }
    }
}
