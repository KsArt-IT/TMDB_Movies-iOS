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
    case poster(path: String)
    case posterSmall(path: String)
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
                getUrl(
                    path: "/\(id)",
                    query: [
                        TmdbEndpoint.languageParam: language,
                    ]
                )
            case let .moviesTop(page, language):
                getUrl(
                    path: "/top_rated",
                    query: [
                        TmdbEndpoint.pageParam: "\(page)",
                        TmdbEndpoint.languageParam: language,
                    ]
                )
            case let .poster(path):
                getUrl(
                    url: TmdbEndpoint.posterURL,
                    path: "/\(TmdbEndpoint.posterBig)\(path)"
                    )
            case let .posterSmall(path):
                getUrl(
                    url: TmdbEndpoint.posterURL,
                    path: "/\(TmdbEndpoint.posterSmall)\(path)"
                    )
        }
    }

    var method: String {
        switch self {
            case .movie, .moviesTop, .poster, .posterSmall:
                return "GET"
        }
    }

}

// MARK: - private
private extension TmdbEndpoint {
    func getUrl(url: String = TmdbEndpoint.baseURL, path: String, query params: [String: String] = [:]) -> URL? {
        guard var components = URLComponents(string: url) else { return nil }

        components.path += path

        let queryItems = [toQueryItem(key: TmdbEndpoint.apiKeyParam, value: TmdbEndpoint.apiKey)]
        components.queryItems = queryItems + params.map(toQueryItem)

        return components.url
    }

    func toQueryItem(key: String, value: String) -> URLQueryItem {
        URLQueryItem(name: key, value: value)
    }

    static let baseURL = "https://api.themoviedb.org/3/movie"
    static let posterURL = "https://image.tmdb.org/t/p"
    static let posterBig = "w500"
    static let posterSmall = "w92"
    // Query params
    static let pageParam = "page"
    static let languageParam = "language"
    static let apiKeyParam = "api_key"

    // api key
    static let apiKey = "4529c2ce63f196742fdf84fa993b9926"
}

/*
 //movie-top-rated
 //https://developer.themoviedb.org/reference/movie-top-rated-list
 //
 //image configuration
 //https://developer.themoviedb.org/reference/configuration-details
 {
   "images": {
     "base_url": "http://image.tmdb.org/t/p/",
     "secure_base_url": "https://image.tmdb.org/t/p/",
     "backdrop_sizes": [
       "w300",
       "w780",
       "w1280",
       "original"
     ],
     "logo_sizes": [
       "w45",
       "w92",
       "w154",
       "w185",
       "w300",
       "w500",
       "original"
     ],
     "poster_sizes": [
       "w92",
       "w154",
       "w185",
       "w342",
       "w500",
       "w780",
       "original"
     ],
     "profile_sizes": [
       "w45",
       "w185",
       "h632",
       "original"
     ],
     "still_sizes": [
       "w92",
       "w185",
       "w300",
       "original"
     ]
   },
   "change_keys": [
     "adult",
     "air_date",
     "also_known_as",
     "alternative_titles",
     "biography",
     "birthday",
     "budget",
     "cast",
     "certifications",
     "character_names",
     "created_by",
     "crew",
     "deathday",
     "episode",
     "episode_number",
     "episode_run_time",
     "freebase_id",
     "freebase_mid",
     "general",
     "genres",
     "guest_stars",
     "homepage",
     "images",
     "imdb_id",
     "languages",
     "name",
     "network",
     "origin_country",
     "original_name",
     "original_title",
     "overview",
     "parts",
     "place_of_birth",
     "plot_keywords",
     "production_code",
     "production_companies",
     "production_countries",
     "releases",
     "revenue",
     "runtime",
     "season",
     "season_number",
     "season_regular",
     "spoken_languages",
     "status",
     "tagline",
     "title",
     "translations",
     "tvdb_id",
     "tvrage_id",
     "type",
     "video",
     "videos"
   ]
 } */
