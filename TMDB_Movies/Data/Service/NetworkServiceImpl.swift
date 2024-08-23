//
//  CoinNetworkServiceImpl.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import Foundation

final class NetworkServiceImpl: NetworkService {

    func loadData<T: Decodable>(endpoint: TmdbEndpoint) async -> Result<T, Error> {
        guard let request = endpoint.request else {
            return .failure(NetworkServiceError.invalidRequest)
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkServiceError.invalidResponse)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let errorResponse: ErrorResponse = try decode(data: data)
                return .failure(NetworkServiceError.statusCode(
                    code: httpResponse.statusCode,
                    message: errorResponse.statusMessage
                ))
            }

            let result: T = try decode(data: data)
            return .success(result)

        } catch let decodingError as DecodingError {
            return .failure(NetworkServiceError.decodingError(decodingError))
        } catch {
            return .failure(NetworkServiceError.networkError(error))
        }
    }

    private func decode<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
