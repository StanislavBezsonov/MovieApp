import SwiftUI

struct PersonRowCell: View {
    let details: PersonDisplayModel

    private let imageWidth: CGFloat = 60
    private let imageHeight: CGFloat = 80

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            AsyncImage(url: details.imageURL) { phase in
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
                Text(details.name)
                    .font(.headline)
                if let subtitle = details.subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxHeight: imageHeight, alignment: .center)
        }
        .frame(height: imageHeight)
    }
}
