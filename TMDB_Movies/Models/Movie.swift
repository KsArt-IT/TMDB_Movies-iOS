//
//  MovieDTO.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import Foundation

struct Movie {
    let id: Int
    let title: String
    let originalTitle: String
    let originalLanguage: String
    let releaseDate: String

    let genres: [String]

    let posterPath: String
    let backdropPath: String

    let overview: String

    let genreIds: [Int]

    let adult: Bool
    let popularity: Double
    let voteCount: Int
    let voteAverage: Double

    let video: Bool
}
