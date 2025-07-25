import SwiftUI

struct MovieDetailView: View {
    let movieId: Int
    
    @StateObject private var viewModel: MovieDetailViewModel
    
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
                        Text(details.reviewsCountText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let overview = viewModel.movieDetail?.overview {
                        OverviewCell(overview: overview)
                            .listRowInsets(EdgeInsets())
                    }
                    
                    Section {
                        if let keywords = details.keywords {
                            KeywordsCell(keywords: keywords)
                                .listRowInsets(EdgeInsets())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cast")
                                .font(.headline)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    if let cast = viewModel.movieDetail?.cast {
                                        ForEach(cast) { person in
                                            PersonCellView(imageURL: person.profileURL, name: person.name, subtitle: person.character)
                                                .listRowInsets(EdgeInsets())
                                        }
                                    }
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        }
                            
                        if let director = details.director {
                            HStack {
                                Text("Director:")
                                    .fontWeight(.semibold)
                                Text(director.name)
                            }
                        }
                            
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Crew")
                                .font(.headline)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    if let crew = viewModel.movieDetail?.crew {
                                        ForEach(crew) { person in
                                            PersonCellView(imageURL: person.profileURL, name: person.name, subtitle: person.job)
                                                .listRowInsets(EdgeInsets())
                                        }
                                    }
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        }
                                
                                if let details = viewModel.movieDetail {
                                    
                                    if details.hasSimilarMovies, let similar = details.similarMovies {
                                        MovieHorizontalSectionView(title: "Similar Movies", movies: similar)
                                    }
                                    
                                    if details.hasRecommendedMovies, let recommended = details.recommendedMovies {
                                        MovieHorizontalSectionView(title: "Recommended", movies: recommended)
                                    }
                                    
                                    if details.hasPosters, let posters = details.images?.posters {
                                        MovieImageSectionView(title: "Other Posters", images: posters) { url in
                                            PosterImageCell(imageURL: url)
                                        }
                                    }
                                    
                                    if details.hasBackdrops, let backdrops = details.images?.backdrops {
                                        MovieImageSectionView(title: "Images", images: backdrops) { url in
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
            }
        }
