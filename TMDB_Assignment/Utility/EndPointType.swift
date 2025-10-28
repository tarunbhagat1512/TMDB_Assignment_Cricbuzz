//
//  EndPointType.swift
//  TMDB_Assignment
//
//  Created by Tarun on 27/10/25.
//

import Foundation

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}
