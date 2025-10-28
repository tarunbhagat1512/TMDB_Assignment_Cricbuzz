//
//  EventEnum.swift
//  TMDB_Assignment
//
//  Created by Tarun on 27/10/25.
//

import Foundation

enum Event {
    case loading
    case stopLoading
    case dataLoaded
    case error(Error?)
}
