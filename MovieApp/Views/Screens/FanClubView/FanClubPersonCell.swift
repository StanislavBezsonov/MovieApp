import SwiftUI

struct FanClubPersonCell: View {
    let imageHeight: CGFloat = 135
    let imageWidth: CGFloat = 100
    
    let person: Person
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
                AsyncImage(url: person.imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageWidth, height: imageHeight)
                            .clipped()
                            .cornerRadius(8)
                    default:
                        Rectangle()
                            .fill((Color.gray.opacity(0.3)))
                            .frame(width: imageWidth, height: imageHeight)
                            .cornerRadius(8)
                            .overlay(
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                            )
                    }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(person.name)
                    .font(.headline)
                
                if let movieTitles = person.movieTitles, !movieTitles.isEmpty {
                    Text(movieTitles.prefix(3).joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxHeight: imageHeight, alignment: .center)
        }
        .frame(maxWidth: .infinity, minHeight: imageHeight, alignment: .leading)
    }
}
