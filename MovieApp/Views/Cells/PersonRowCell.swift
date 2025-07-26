import SwiftUI

struct PersonRowCell: View {
    let imageURL: URL?
    let name: String
    let subtitle: String?

    // Константы для размеров
    private let imageWidth: CGFloat = 60
    private let imageHeight: CGFloat = 80

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            AsyncImage(url: imageURL) { phase in
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
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                if let subtitle, !subtitle.isEmpty {
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
