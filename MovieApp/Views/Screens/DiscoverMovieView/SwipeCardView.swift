import SwiftUI

enum SwipeDirection {
    case left, right, down
}

struct SwipeCardView: View {
    let movie: Movie
    var onSwipe: (SwipeDirection) -> Void
    var onDragChanged: (CGSize) -> Void
    var onDragEnded: () -> Void
    
    @State private var offset: CGSize = .zero
    @GestureState private var dragState = DragState.inactive
    @State private var isSwipedAway = false
    
    var body: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width * 0.7
            let cardHeight = cardWidth * 4 / 3
            
            VStack {
                VStack(spacing: 16) {
                    AsyncImage(url: movie.posterURL) { phase in
                        switch phase {
                        case .success(let img):
                            img
                                .resizable()
                                .scaledToFill()
                                .frame(width: cardWidth, height: cardHeight)
                                .clipped()
                                .cornerRadius(12)
                        case .failure:
                            Color.gray.frame(width: cardWidth, height: cardHeight).cornerRadius(12)
                        case .empty:
                            ProgressView().frame(width: cardWidth, height: cardHeight)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    Text(movie.title)
                        .font(.title2)
                        .bold()
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .frame(width: cardWidth)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .offset(x: offset.width + dragState.translation.width,
                    y: offset.height + dragState.translation.height)
            .rotationEffect(.degrees(Double(offset.width + dragState.translation.width) / 20))
            .opacity(isSwipedAway ? 0 : 1)
            .animation(.easeInOut(duration: 0.9), value: isSwipedAway)
            .gesture(
                DragGesture()
                    .updating($dragState) { value, state, _ in
                        state = .dragging(translation: value.translation)
                        onDragChanged(CGSize(width: offset.width + value.translation.width,
                                             height: offset.height + value.translation.height))
                    }
                    .onEnded { value in
                        let thresholdX = geometry.size.width * 0.1
                        let thresholdY = geometry.size.height * 0.1
                        
                        let absX = abs(value.translation.width)
                        let absY = abs(value.translation.height)
                        
                        if absX > absY && absX > thresholdX {
                            if value.translation.width > 0 {
                                swipeOut(to: .right)
                            } else {
                                swipeOut(to: .left)
                            }
                        } else if absY > absX && value.translation.height > thresholdY {
                            swipeOut(to: .down)
                        } else {
                            withAnimation(.spring()) {
                                offset = .zero
                                onDragChanged(.zero)
                            }
                        }
                    }
            )
        }
    }
    
    private func swipeOut(to direction: SwipeDirection) {
        withAnimation(.easeInOut(duration: 0.3)) {
            isSwipedAway = true
            switch direction {
            case .right:
                offset = CGSize(width: 1000, height: 0)
            case .left:
                offset = CGSize(width: -1000, height: 0)
            case .down:
                offset = CGSize(width: 0, height: 1000)
            }
            onDragChanged(.zero)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onSwipe(direction)
        }
    }

    enum DragState {
        case inactive
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive: return .zero
            case .dragging(let translation): return translation
            }
        }
    }
}
