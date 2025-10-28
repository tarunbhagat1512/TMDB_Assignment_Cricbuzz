//
//  Movies.swift
//  TMDB_Assignment
//
//  Created by Tarun on 27/10/25.
//

import Foundation

struct Movies: Codable {
    var page: Int?
    var results: [MovieDetails]
    
    
}

struct MovieDetails: Codable {
    
    var adult: Bool?
    var backdrop_path: String?
    var id: Int?
    var original_language: String?
    var original_title: String?
    var genre_ids: [Int]?
    var overview: String?
    var popularity: Double?
    var poster_path: String?
    var release_date: String?
    var title: String?
    var video: Bool?
    var vote_average: Double?
    var vote_count: Int?
    
    init() {
        
    }
    
}
