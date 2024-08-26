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
            let data = try await executeRequest(request)

            let result: T = try decode(data: data)

            return .success(result)

        } catch let error as NetworkServiceError {
            return .failure(error)
        } catch let error as DecodingError {
            return .failure(NetworkServiceError.decodingError(error))
        } catch let error as URLError where error.code == .cancelled {
            return .failure(NetworkServiceError.cancelled)
        } catch {
            print("NetworkServiceImpl: \(error)")
            return .failure(NetworkServiceError.networkError(error))
        }
    }

    private func executeRequest(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkServiceError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorResponse: ErrorResponse = try decode(data: data)
            throw NetworkServiceError.statusCode(
                code: httpResponse.statusCode,
                message: errorResponse.statusMessage
            )
        }
        return data
    }

    private func decode<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
