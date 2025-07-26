import SwiftUI

struct MovieImageSection<Content: View>: View {
    let title: String
    let images: [ImageData]
    let cellBuilder: (URL) -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(images, id: \.filePath) { image in
                        if let url = image.url {
                            cellBuilder(url)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }
}
