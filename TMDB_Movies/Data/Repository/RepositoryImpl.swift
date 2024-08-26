//
//  RepositoryImpl.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import Foundation

final class RepositoryImpl: Repository {

    private let service: NetworkService

    init(service: NetworkService) {
        self.service = service
    }

    func fetchTopMovies(page: Int) async -> Result<[Movie], Error> {
        let result: Result<MovieTopDTOResponse, Error> = await service.loadData(endpoint: .moviesTop(page: page))
        return switch result {
            case .success(let movieTopDTOs): .success(movieTopDTOs.results.map { $0.mapToDomain() })
            case .failure(let error): .failure(error)
        }
    }

    func fetchMovie(id: Int) async -> Result<Movie, any Error> {
        let result: Result<MovieDTO, Error> = await service.loadData(endpoint: .movie(id: id))
        return switch result {
            case .success(let movieDTO): .success(movieDTO.mapToDomain())
            case .failure(let error): .failure(error)
        }
    }

    func fetchMoviePoster(path: String, small: Bool) async -> Result<Data, any Error> {
        let result: Result<Data, Error> = await service.loadData(
            endpoint: small ? .posterSmall(path: path): .poster(path: path)
        )
        return switch result {
            case .success(let data): .success(data)
            case .failure(let error): .failure(error)
        }
    }

}

