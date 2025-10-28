//
//  MovieEndPoint.swift
//  TMDB_Assignment
//
//  Created by Tarun on 27/10/25.
//

import Foundation

enum MovieEndPoint {
    case fetchMoviesList
    case searchMovies(quert: String)
    
    case fetchMovieDetails(id: Int)
    case fetchTrailer(id: Int)
    
}

extension MovieEndPoint: EndPointType {

    var path: String {
        switch self {
            
        case .fetchMoviesList:
            return "movie/popular"
            
        case .searchMovies(quert: let query):
            return "search/movie?query=\(query)"
            
        case .fetchMovieDetails(id: let id):
            return "/movie/\(id)"
            
        case .fetchTrailer(id: let id):
            return "movie/\(id)/videos"
        }
    }

    var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
        
        return .get
//        switch self {
//        
//        case .fetchMoviesList:
//            return .get
//            
//        case .searchMovies:
//            return .get
//            
//        case .fetchMovieDetails:
//            return .get
//            
//        case .fetchTrailer:
//            return .get
//        }
    }

    var body: Encodable? {
//        switch self {
//            
//        case .fetchMoviesList:
//            return nil
//            
//        case .searchMovies:
//            return nil
//            
//        case .fetchMovieDetails:
//            return nil
//            
//        case .fetchTrailer:
//            return nil
//        }
        return nil
    }

    var headers: [String : String]? {
        ApiManager.commonHeaders
    }
}
