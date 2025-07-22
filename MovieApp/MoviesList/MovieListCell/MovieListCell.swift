import SwiftUI

struct MovieListCell: View {
    @ObservedObject var viewModel: MovieListCellViewModel
    
    let imageWidth: CGFloat = 100
    let imageHeight: CGFloat = 150
    var placeholderImage: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 150)
            .foregroundColor(.gray)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let url = viewModel.posterURL {
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
            
            
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(viewModel.formattedReleaseDate)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(viewModel.overview)
                    .font(.body)
                    .lineLimit(4)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
        }
        .padding(.vertical, 8)
    }
}
