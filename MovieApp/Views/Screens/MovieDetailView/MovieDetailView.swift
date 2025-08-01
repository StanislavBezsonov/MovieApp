import SwiftUI

struct MovieDetailView: View {
    let movieId: Int
    
    @StateObject private var viewModel: MovieDetailViewModel
    @StateObject private var posterVM = PosterListViewModel(images: [])
    @StateObject private var backdropVM = PosterListViewModel(images: [])
    
    init(movieId: Int, movieService: MovieServiceProtocol = Current.movieService, userMoviesList: UserMoviesStorage = UserMoviesStorage(), coordinator: AppCoordinator? = nil) {
        self.movieId = movieId
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId, movieService: movieService, userMoviesList: userMoviesList, coordinator: coordinator))
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
                    MovieActionCell(movieLists: viewModel.userMoviesList, movieId: details.id)
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
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.personTapped(director.toPersonDisplayModel())
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
                                    onSeeAllTapped: { viewModel.seeAllSimilarTapped()},
                                    onMovieTapped: { movie in
                                        viewModel.movieTapped(movie)
                                    }
                                )
                            }
                            
                            if details.hasRecommendedMovies, let recommended = details.recommendedMovies {
                                MovieHorizontalSection(
                                    title: "Recommended Movies",
                                    movies: recommended,
                                    onSeeAllTapped: { viewModel.seeAllRecommendedTapped()},
                                    onMovieTapped: { movie in
                                        viewModel.movieTapped(movie)
                                    }
                                )
                            }
                            
                            
                            if details.hasPosters {
                                MovieImageSection(viewModel: posterVM, title: "Other Posters") { url in
                                    PosterImageCell(imageURL: url)
                                }
                            }
                            
                            if details.hasBackdrops {
                                MovieImageSection(viewModel: backdropVM, title: "Images") { url in
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
            viewModel.onViewAppeared()
        }
        .onChange(of: viewModel.movieDetail) { detail in
            if let posters = detail?.images?.posters {
                posterVM.updateImages(posters)
            }
            if let backdrops = detail?.images?.backdrops {
                backdropVM.updateImages(backdrops)
            }
        }
    }
}
