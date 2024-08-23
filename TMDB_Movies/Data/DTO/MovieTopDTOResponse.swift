//
//  MovieTopRatedResponse.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import Foundation

struct MovieTopDTOResponse: Decodable {
    let page: Int
    let results: [MovieTopDTO]
    let totalPages: Int
    let totalResults: Int
}
