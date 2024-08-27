//
//  R.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import UIKit

enum R {

    enum Strings {
        static let language = String(localized: "language")
        static let titleTopMovies = String(localized: "titleTopMovies")
        static let titleMovieDetail = String(localized: "movieInfo")
    }

    enum Images {
        static let poster = UIImage(named: "poster") ?? UIImage()
    }
}
