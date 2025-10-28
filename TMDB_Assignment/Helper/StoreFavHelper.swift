//
//  StoreFavHelper.swift
//  TMDB_Assignment
//
//  Created by Tarun on 27/10/25.
//

import Foundation

final class StoreFavHelper {
    static let shared = StoreFavHelper()
    private let key = "fav_movie_ids"
    private var set: Set<Int>
    
    private init() {
        let arr = UserDefaults.standard.array(forKey: key) as? [Int] ?? []
        set = Set(arr)
    }
    
    func isFavorite(_ id: Int) -> Bool {
        set.contains(id)
    }
    
    func toggle(_ id: Int) {
        if set.contains(id) { set.remove(id) } else { set.insert(id) }
        UserDefaults.standard.set(Array(set), forKey: key)
    }
}

