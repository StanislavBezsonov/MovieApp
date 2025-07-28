import SwiftUI

struct PersonMainDetailsCell: View {
    let person: PersonDetail
    
    private let imageWidth: CGFloat = 120
    private let imageHeight: CGFloat = 150
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            AsyncImage(url: person.imageURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth, height: imageHeight)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
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
                
                if let age = person.age {
                    Text("\(age) years old")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let placeOfBirth = person.placeOfBirth {
                    Text(placeOfBirth)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                if let department = person.department {
                    Text(department)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let popularity = person.popularity {
                    CircularRatingView(rating: popularity, textColor: .appBlack)
                        .frame(width: 44, height: 44)
                }
            }
            .frame(maxHeight: imageHeight, alignment: .center)
        }
    }
}
