import SwiftUI

struct MoviePosterView: View {
    let movie: Movie
    
    private let imageWidth: CGFloat = 100
    private let imageHeight: CGFloat = 150
    
    var body: some View {
        VStack(alignment: .center) {
            if let url = movie.posterURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: imageWidth, height: imageHeight)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageWidth, height: imageHeight)
                            .clipped()
                            .cornerRadius(8)
                    case .failure:
                        placeholderImage
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                placeholderImage
            }
        }
    }
    
    private var placeholderImage: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: imageWidth, height: imageHeight)
            .foregroundColor(.gray)
    }
}

