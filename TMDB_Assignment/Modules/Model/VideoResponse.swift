//
//  VideoResponse.swift
//  TMDB_Assignment
//
//  Created by Tarun on 28/10/25.
//

import Foundation

struct VideoResponse: Codable {
    let id: Int?
    let results: [Video]
}
    
struct Video: Codable {
    let key: String
    let type: String?
    let official: Bool?
    let name: String?
    let site: String?
    let size: Int?
    let publishedAt: String?

    enum CodingKeys: String, CodingKey {
        case key, type, official, name, site, size
        case publishedAt = "published_at"
    }
}



