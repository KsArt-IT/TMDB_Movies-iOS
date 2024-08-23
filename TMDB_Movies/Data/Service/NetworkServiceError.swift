//
//  NetworkError.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import Foundation

enum NetworkServiceError: Error {
    case invalidRequest
    case invalidResponse
    case statusCode(code: Int, message: String)
    case decodingError(DecodingError)
    case networkError(Error)

    var localizedDescription: String {
        switch self {
        case .invalidRequest:
            return "The request is invalid."
        case .invalidResponse:
            return "The response is invalid."
        case .statusCode(let code, let message):
            return "Unexpected status code: \(code). \(message)"
        case .decodingError(let error):
            return "Decoding failed with error: \(error.localizedDescription)."
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)."
        }
    }
}

struct ErrorResponse: Decodable {
    let statusCode: Int
    let statusMessage: String //"Invalid API key: You must be granted a valid key."
    let success: Bool
}
