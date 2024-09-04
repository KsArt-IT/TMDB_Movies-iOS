//
//  RepositoryDependency.swift
//  TMDB_Movies
//
//  Created by KsArT on 04.09.2024.
//

import Foundation
import NeedleFoundation

protocol RepositoryDependency: Dependency {
    var networkService: NetworkService { get }
    var repository: Repository { get }
}
