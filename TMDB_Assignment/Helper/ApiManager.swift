//
//  ApiManager.swift
//  TMDB_Assignment
//
//  Created by Tarun on 27/10/25.
//

import Foundation
import UIKit

typealias Handler<T> = ( Result<T, DataError> ) -> Void


final class ApiManager {
    
    static let shared = ApiManager()
    private init() {}
    
    func request<T: Codable>(
        modelType: T.Type,
        type: EndPointType,
        completion: @escaping Handler<T>) {

            guard let url = type.url else {
                completion(.failure(.invalidURL))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = type.method.rawValue


            if let parementer = type.body {
                request.httpBody = try? JSONEncoder().encode(parementer)
            }

            request.allHTTPHeaderFields = type.headers


        URLSession.shared.dataTask(with: request) { data, response, erroe in

            guard let data, erroe == nil else {
                completion(.failure(.invalidData))
                return
            }

            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {

                let response = response as? HTTPURLResponse

                print("HTTP Error code = \(response?.statusCode)")

                completion(.failure(.invalidResponse))
                return
            }

            do {
                let data = try JSONDecoder().decode(modelType, from: data)
                completion(.success(data))
            } catch {
                completion(.failure(.network(error)))
            }

        }.resume()

    }
    
    static var commonHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZWJlZGEyNzc3YTI5MGVkZmMxNDk1ZmI0ZWFkZWRjMiIsIm5iZiI6MTc1MTYwODMwOS42NDEsInN1YiI6IjY4Njc2YmY1MDA3MTZlNTE2YzVlMzY0OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.C_0K7j-8VCXTkTVtd7Ibdre0-dOh5fF-VqlgH3hRFlU"
        ]
    }
}


extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let dict = json as? [String: Any] else {
            throw NSError(domain: "Invalid JSON", code: -1, userInfo: nil)
        }
        return dict
    }
}
