//
//  ErrorEnum.swift
//  TMDB_Assignment
//
//  Created by Tarun on 27/10/25.
//

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}
