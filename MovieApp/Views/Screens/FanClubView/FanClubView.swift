import SwiftUI

struct FanClubView: View {
    
    @StateObject private var viewModel: FanClubViewModel
    
    init(title:String, movieService: MovieServiceProtocol = Current.movieService, coordinator: AppCoordinator? = nil) {
        _viewModel = StateObject(wrappedValue: FanClubViewModel(title:title, movieService: movieService, coordinator: coordinator))
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.fanClub) { person in
                    FanClubPersonCell(person: person)                    
                }
            }

        }
        .onAppear {
            viewModel.onViewAppeared()
        }
    }
}
    

