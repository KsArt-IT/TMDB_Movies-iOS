//
//  TmdbEndpoint.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import Foundation

enum TmdbEndpoint {
    case movie(id: Int, language: String = R.Strings.language)
    case moviesTop(page: Int = 1, language: String = R.Strings.language)
}

// MARK: - fields
extension TmdbEndpoint {

    var request: URLRequest? {
        guard let url = self.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
        ]

        return request
    }

    var url: URL? {
        switch self {
            case let .movie(id, language):
                return getUrl(
                    path: "/\(id)",
                    query: [
                        TmdbEndpoint.languageParam: language,
                    ]
                )
            case let .moviesTop(page, language):
                return getUrl(
                    path: "/top_rated",
                    query: [
                        TmdbEndpoint.pageParam: "\(page)",
                        TmdbEndpoint.languageParam: language,
                    ]
                )
        }
    }

    var method: String {
        switch self {
            case .movie, .moviesTop:
                return "GET"
        }
    }

}

// MARK: - private
private extension TmdbEndpoint {
    func getUrl(path: String, query params: [String: String] = [:]) -> URL? {
        guard var components = URLComponents(string: TmdbEndpoint.baseURL) else { return nil }

        components.path += path

        let queryItems = [toQueryItem(key: TmdbEndpoint.apiKeyParam, value: TmdbEndpoint.apiKey)]
        components.queryItems = queryItems + params.map(toQueryItem)

        return components.url
    }

    func toQueryItem(key: String, value: String) -> URLQueryItem {
        URLQueryItem(name: key, value: value)
    }

    static let baseURL = "https://api.themoviedb.org/3/movie"
    // Query params
    static let pageParam = "page"
    static let languageParam = "language"
    static let apiKeyParam = "api_key"

    // api key
    static let apiKey = "4529c2ce63f196742fdf84fa993b9926"
}
