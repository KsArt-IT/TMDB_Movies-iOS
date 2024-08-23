//
//  CoinNetworkService.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import Foundation

protocol NetworkService {
    func loadData<T: Decodable>(endpoint: TmdbEndpoint) async -> Result<T, Error>
}
