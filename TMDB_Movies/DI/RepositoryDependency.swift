//
//  RepositoryDependency.swift
//  TMDB_Movies
//
//  Created by KsArT on 04.09.2024.
//

import Foundation
import NeedleFoundation

protocol RepositoryDependency: Dependency {
    var repository: Repository { get }
}
