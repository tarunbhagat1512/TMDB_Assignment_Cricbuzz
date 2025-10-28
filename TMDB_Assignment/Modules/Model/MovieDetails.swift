//
//  MovieDetails.swift
//  TMDB_Assignment
//
//  Created by Tarun on 28/10/25.
//

import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let originalTitle: String?
    let originalLanguage: String?
    let overview: String?
    let tagline: String?
    let status: String?
    let adult: Bool?
    let video: Bool?
    let popularity: Double?
    let voteAverage: Double?
    let voteCount: Int?
    let posterPath: String?
    let backdropPath: String?
    let homepage: String?
    let imdbID: String?
    let releaseDateString: String?
    let runtime: Int?
    let budget: Int?
    let revenue: Int?
    let genres: [Genre]?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let spokenLanguages: [SpokenLanguage]?
    let originCountry: [String]?

    var releaseDate: Date? {
        guard let ds = releaseDateString, !ds.isEmpty else { return nil }
        return Movie.dateFormatter.date(from: ds)
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    enum CodingKeys: String, CodingKey {
        case id, title, overview, tagline, status, adult, video, popularity, runtime, budget, revenue, genres, homepage
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case imdbID = "imdb_id"
        case releaseDateString = "release_date"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case spokenLanguages = "spoken_languages"
        case originCountry = "origin_country"
    }
}

struct Genre: Codable, Hashable {
    let id: Int?
    let name: String?
}

struct ProductionCompany: Codable, Hashable {
    let id: Int?
    let name: String?
    let logoPath: String?
    let originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

struct ProductionCountry: Codable, Hashable {
    let iso3166_1: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

struct SpokenLanguage: Codable, Hashable {
    let englishName: String?
    let iso639_1: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}
