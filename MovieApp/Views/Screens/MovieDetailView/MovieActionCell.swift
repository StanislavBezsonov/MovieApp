import SwiftUI

struct MovieActionCell: View {
    var movieLists: UserMoviesStorage
    let movieId: Int
    
    @State private var isInWishlist = false
    @State private var isInSeenlist = false
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                if isInWishlist {
                    movieLists.removeMovie(movieId, from: .wishlist)
                    isInWishlist = false
                } else {
                    movieLists.addMovie(movieId, to: .wishlist)
                    isInWishlist = true
                }
            }) {
                Text("Wishlist")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(isInWishlist ? Color.blue : Color.clear)
                    .foregroundColor(isInWishlist ? .white : .blue)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                if isInSeenlist {
                    movieLists.removeMovie(movieId, from: .seenlist)
                    isInSeenlist = false
                } else {
                    movieLists.addMovie(movieId, to: .seenlist)
                    isInSeenlist = true
                }
            }){
                Text("Seenlist")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(isInSeenlist ? Color.green : Color.clear)
                    .foregroundColor(isInSeenlist ? .white : .green)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.green, lineWidth: 1)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
        .onAppear {
            refreshStates()
        }
    }
    
    private func refreshStates() {
        isInWishlist = movieLists.isMovie(movieId, in: .wishlist)
        isInSeenlist = movieLists.isMovie(movieId, in: .seenlist)
    }
}
