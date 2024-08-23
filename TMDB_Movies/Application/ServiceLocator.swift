//
//  ServiceLocator.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import Foundation

final class ServiceLocator {

    static let shared = ServiceLocator(); private init() {}

    private var services: [String: Any] = [:]

    func register<T>(service: T) {
        services["\(T.self)"] = service
    }

    func resolve<T>() -> T? {
        services["\(T.self)"] as? T
    }
}
