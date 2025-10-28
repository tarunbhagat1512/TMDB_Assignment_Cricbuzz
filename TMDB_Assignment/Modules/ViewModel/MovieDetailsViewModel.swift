//
//  MovieDetailsViewModel.swift
//  TMDB_Assignment
//
//  Created by Tarun on 28/10/25.
//

import Foundation

final class MovieDetailsViewModel {
    
    
    var Details: Movie?
    var eventHandler: ((_ event: Event) -> Void)?
    
    func fetchMovieDetail(id: Int) {
        self.eventHandler?(.loading)
        ApiManager.shared.request(modelType: Movie.self,
                                  type: MovieEndPoint.fetchMovieDetails(id: id)) { result in
            switch result {
            case .success(let data):
                self.eventHandler?(.movieDetailFetched(data: data))
                
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
    }
    
    func fetchTrailer(id: Int) {
        
        self.eventHandler?(.loading)
        ApiManager.shared.request(modelType: VideoResponse.self,
                                  type: MovieEndPoint.fetchTrailer(id: id)) { result in
            switch result {
                
            case .success(let data):
                self.eventHandler?(.trailerFetched(data: data.results))
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
        
    }
    
}

extension MovieDetailsViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
        case movieDetailFetched(data: Movie)
        case trailerFetched(data: [Video])
    }

}
