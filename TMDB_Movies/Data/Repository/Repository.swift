//
//  CoinRepository.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import Foundation

protocol Repository: AnyObject {
    func fetchTopMovies(page: Int) async -> Result<[Movie], Error>
    func fetchTopMoviesCount() async -> Result<(pages: Int, count: Int), Error>
    func fetchMovie(id: Int) async -> Result<Movie, Error>
    func fetchMoviePoster(path: String, small: Bool) async -> Result<Data, Error>
}
