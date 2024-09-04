//
//  RepositoryComponent.swift
//  TMDB_Movies
//
//  Created by KsArT on 04.09.2024.
//

import Foundation
import NeedleFoundation

class RepositoryComponent: Component<RepositoryDependency> {
    private var networkService: NetworkService {
        shared { NetworkServiceImpl() }
    }

    public var repository: Repository {
        shared { RepositoryImpl(service: networkService) }
    }
}
