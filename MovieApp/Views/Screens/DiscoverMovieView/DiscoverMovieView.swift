import SwiftUI

struct DiscoverMovieView: View {
    @StateObject private var viewModel: DiscoverMovieViewModel
    @State private var showingSettings = false

    init(coordinator: AppCoordinator) {
        _viewModel = StateObject(wrappedValue: DiscoverMovieViewModel(movieService: MovieService(), storage: UserMoviesStorage(), coordinator: coordinator))
    }
    
    var body: some View {
        ZStack {
            if let message = viewModel.swipeMessage {
                Text("\(message.icon) \(message.text)")
                    .font(.headline)
                    .padding(10)
                    .background(Color.black.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .opacity(message.opacity)
                    .offset(y: -250)
                    .zIndex(1000)
            }
            
            ForEach(Array(viewModel.movies.prefix(3).enumerated()), id: \.element.id) { index, movie in
                SwipeCardView(
                    movie: movie,
                    onSwipe: { direction in
                        withAnimation {
                            viewModel.handleSwipe(movie: movie, direction: direction)
                        }
                    },
                    onDragChanged: { offset in
                        viewModel.updateSwipeOffset(offset)
                    },
                    onDragEnded: {
                        viewModel.resetSwipeOffset()
                    }
                )
                .offset(x: viewModel.cardOffset(for: index))
                .rotationEffect(.degrees(viewModel.cardRotation(for: index)))
                .scaleEffect(viewModel.cardScale(for: index))
                .zIndex(Double(viewModel.movies.count - index))
                .animation(.easeInOut(duration: 0.3), value: viewModel.movies)
            }
        }
        .padding()
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSettings = true
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            DiscoverFilterView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.onViewAppeared()
        }
    }
}
