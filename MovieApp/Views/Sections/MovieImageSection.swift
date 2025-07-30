import SwiftUI

struct MovieImageSection<Content: View>: View {
    @ObservedObject var viewModel: PosterListViewModel
    
    let title: String
    let cellBuilder: (URL) -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(viewModel.visibleImages, id: \.filePath) { image in
                        if let url = image.url {
                            cellBuilder(url)
                                .onAppear {
                                    if image == viewModel.visibleImages.last {
                                        viewModel.loadMoreIfNeeded(currentItem: image)
                                    }
                                }
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

