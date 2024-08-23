//
//  MovieTop.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import Foundation

struct MovieTopDTO: Decodable {
    let id: Int
    let title: String?
    let originalTitle: String?
    let originalLanguage: String?
    let releaseDate: String?

    let posterPath: String?
    let backdropPath: String?

    let overview: String?

    let genreIds: [Int]?

    let adult: Bool?
    let popularity: Double?
    let voteCount: Int?
    let voteAverage: Double?

    let video: Bool?
}

extension MovieTopDTO {

    func mapToDomain() -> Movie {
        Movie(
            id: self.id,
            title: self.title ?? "",
            originalTitle: self.originalTitle ?? "",
            originalLanguage: self.originalLanguage ?? "",
            releaseDate: self.releaseDate ?? "",
            genres: [],
            posterPath: self.posterPath ?? "",
            backdropPath: self.backdropPath ?? "",
            overview: self.overview ?? "",
            genreIds: self.genreIds ?? [],
            adult: self.adult ?? false,
            popularity: self.popularity ?? Double.nan,
            voteCount: self.voteCount ?? 0,
            voteAverage: self.voteAverage ?? 0,
            video: self.video ?? false
        )
    }
}
