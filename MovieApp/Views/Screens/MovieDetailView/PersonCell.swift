import SwiftUI

struct PersonCell: View {
    let details: PersonDisplayModel
    
    private let imageWidth: CGFloat = 80
    private let imageHeight: CGFloat = 100

    var body: some View {
        VStack(spacing: 4) {
            AsyncImage(url: details.imageURL) { phase in
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

            Text(details.name)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: imageWidth)
                .multilineTextAlignment(.center)

            if let subtitle = details.subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: imageWidth)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: 100)
    }
}


