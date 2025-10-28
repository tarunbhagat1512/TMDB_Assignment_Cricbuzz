//
//  MovieListViewModel.swift
//  TMDB_Assignment
//
//  Created by Tarun on 27/10/25.
//

import Foundation

final class MovieListViewModel {
    
    var MoviesArray = [MovieDetails]()
    var eventHandler: ((_ event: Event) -> Void)?
    
    func fetchMovie() {
        self.eventHandler?(.loading)
        ApiManager.shared.request(modelType: Movies.self,
                                  type: MovieEndPoint.fetchMoviesList) { result in
            switch result {
            case .success(let data):
                self.eventHandler?(.moviesDetailsFetched(data: data))
                
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
    }
    
    func searchMovie(query: String) {
        self.eventHandler?(.loading)
        ApiManager.shared.request(modelType: Movies.self,
                                  type: MovieEndPoint.searchMovies(quert: query)) { result in
            switch result {
            case .success(let data):
                self.eventHandler?(.movieSearched(data: data))
                
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
        
    }
}

extension MovieListViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
        case moviesDetailsFetched(data: Movies)
        case movieSearched(data: Movies)
    }

}

