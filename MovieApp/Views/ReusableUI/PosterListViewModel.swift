import Combine

class PosterListViewModel: ObservableObject {
    @Published var visibleImages: [ImageData] = []
    private(set) var allImages: [ImageData] = []
    
    private let batchSize = 10
    
    init(images: [ImageData]) {
        updateImages(images)
    }
    
    func updateImages(_ newImages: [ImageData]) {
        allImages = newImages
        visibleImages = Array(allImages.prefix(batchSize))
    }
    
    func loadMoreIfNeeded(currentItem item: ImageData) {
        guard let currentIndex = visibleImages.firstIndex(where: { $0.filePath == item.filePath }) else {
            return
        }

        let thresholdIndex = visibleImages.index(visibleImages.endIndex, offsetBy: -3)
        if currentIndex >= thresholdIndex && visibleImages.count < allImages.count {
            let nextBatchEnd = min(visibleImages.count + batchSize, allImages.count)
            let nextItems = allImages[visibleImages.count..<nextBatchEnd]
            visibleImages.append(contentsOf: nextItems)
        }
    }
}

