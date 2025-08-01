import SwiftUI

struct FanClubView: View {
    
    @StateObject private var viewModel: FanClubViewModel
    
    init(movieService: MovieServiceProtocol = Current.movieService, coordinator: AppCoordinator? = nil) {
        _viewModel = StateObject(wrappedValue: FanClubViewModel(movieService: movieService, coordinator: coordinator))
    }
    
    var body: some View {
        VStack {
            if !viewModel.favoritePersons.isEmpty {
                List {
                    Section(header: Text("Favorites")) {
                        ForEach(viewModel.favoritePersons) { person in
                            FanClubPersonCell(person: person) {
                                viewModel.personTapped(person)
                            }
                        }
                    }

                    Section(header: Text("Popular")) {
                        ForEach(viewModel.fanClub) { person in
                            FanClubPersonCell(person: person) {
                                viewModel.personTapped(person)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            } else {
                List {
                    ForEach(viewModel.fanClub) { person in
                        FanClubPersonCell(person: person) {
                            viewModel.personTapped(person)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.onViewAppeared()
        }
    }
}
    

