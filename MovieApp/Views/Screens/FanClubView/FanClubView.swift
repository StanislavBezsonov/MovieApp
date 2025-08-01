import SwiftUI

struct FanClubView: View {
    
    @StateObject private var viewModel: FanClubViewModel
    
    init(movieService: MovieServiceProtocol = Current.movieService, coordinator: AppCoordinator? = nil) {
        _viewModel = StateObject(wrappedValue: FanClubViewModel(movieService: movieService, coordinator: coordinator))
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.fanClub) { person in
                    FanClubPersonCell(person: person)
                }
            }
            .listStyle(.plain)
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.onViewAppeared()
        }
    }
}
    

