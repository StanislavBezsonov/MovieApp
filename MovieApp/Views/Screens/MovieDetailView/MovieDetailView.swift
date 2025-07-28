import SwiftUI

struct MovieDetailView: View {
    let movieId: Int
    
    @StateObject private var viewModel: MovieDetailViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    
    init(movieId: Int, movieService: MovieServiceProtocol = Current.movieService) {
        self.movieId = movieId
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId, movieService: movieService))
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
            } else if let details = viewModel.movieDetail {
                List {
                    MovieDetailCell(movie: details)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    MovieActionCell()
                        .listRowInsets(EdgeInsets())
                    
                    if details.hasReviews {
                        Button {
                            viewModel.showReviewsTapped()
                        } label: {
                            Text(details.reviewsCountText)
                                .font(.subheadline)
                        }
                    }
                    
                    if let overview = viewModel.movieDetail?.overview {
                        OverviewCell(overview: overview)
                            .listRowInsets(EdgeInsets())
                    }
                    
                    Section {
                        if let keywords = details.keywords {
                            KeywordsCell(keywords: keywords) { keyword in
                                viewModel.keywordTapped(keyword)
                            }
                            .listRowInsets(EdgeInsets())
                        }
                        
                        if let cast = viewModel.movieDetail?.cast {
                            PeopleHorizontalSection(
                                title: "Cast",
                                people: cast.toPersonDisplayModels(),
                                onSeeAllTapped: { viewModel.seeAllCastTapped() },
                                onPersonTapped: { person in
                                    viewModel.personTapped(person)
                                }
                            )
                        }
                        
                        if let director = details.director {
                            HStack {
                                Text("Director:")
                                    .fontWeight(.semibold)
                                Text(director.name)
                            }
                        }
                        
                        if let crew = viewModel.movieDetail?.crew {
                            PeopleHorizontalSection(
                                title: "Crew",
                                people: crew.toPersonDisplayModels(),
                                onSeeAllTapped: { viewModel.seeAllCrewTapped() },
                                onPersonTapped: { person in
                                    viewModel.personTapped(person)
                                }
                            )
                        }
                        
                        if let details = viewModel.movieDetail {
                            
                            if details.hasSimilarMovies, let similar = details.similarMovies {
                                MovieHorizontalSection(
                                    title: "Similar Movies",
                                    movies: similar,
                                    onSeeAllTapped: { viewModel.seeAllSimilarTapped()}
                                )
                            }
                            
                            if details.hasRecommendedMovies, let recommended = details.recommendedMovies {
                                MovieHorizontalSection(
                                    title: "Recommended Movies",
                                    movies: recommended,
                                    onSeeAllTapped: { viewModel.seeAllRecommendedTapped()}
                                )
                            }
                            
                            
                            if details.hasPosters, let posters = details.images?.posters {
                                MovieImageSection(title: "Other Posters", images: posters) { url in
                                    PosterImageCell(imageURL: url)
                                }
                            }
                            
                            if details.hasBackdrops, let backdrops = details.images?.backdrops {
                                MovieImageSection(title: "Images", images: backdrops) { url in
                                    BackdropImageCell(imageURL: url)
                                }
                            }
                        }
                        
                    }
                    
                }
                .navigationTitle(details.title)
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .onAppear {
            viewModel.setCoordinator(coordinator)
            viewModel.onViewAppeared()
        }
    }
}
