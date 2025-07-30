import SwiftUI

struct PersonDetailView: View {
    let personId: Int
    
    @StateObject private var viewModel: PersonDetailViewModel
    @StateObject private var posterVM = PosterListViewModel(images: [])
    
    init(personId: Int, movieService: MovieServiceProtocol = Current.movieService, coordinator: AppCoordinator) {
        self.personId = personId
        _viewModel = StateObject(wrappedValue: PersonDetailViewModel(personId: personId, movieService: movieService, coordinator: coordinator))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if let details = viewModel.personDetail {
                List {
                    PersonMainDetailsCell(person: details)
                    if let bio = details.bio {
                        OverviewCell(overview: bio)
                            .listRowInsets(EdgeInsets())
                    }
                    if let images = details.profileImages?.profiles, !images.isEmpty {
                        let posterVM = PosterListViewModel(images: images)

                        MovieImageSection(viewModel: posterVM, title: "Images") { url in
                            PosterImageCell(imageURL: url)
                        }
                    }
                    
                    ForEach(viewModel.moviesByYear, id: \.year) { year, movies in
                        Section(header: Text("\(year)").font(.headline)) {
                            ForEach(movies) { movie in
                                PersonMoviesCell(movie: movie) {
                                    viewModel.onMovieTapped(movie)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.title)
        .onAppear {
            viewModel.onViewAppear()
        }
    }
}
