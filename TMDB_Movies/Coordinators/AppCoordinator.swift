//
//  AppCoordinator.swift
//  TMDB_Movies
//
//  Created by KsArT on 29.08.2024.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navController: UINavigationController
    
    var childCoordinators: [Coordinator] = []

    init(navController: UINavigationController) {
        self.navController = navController
    }

    func start() {

    }
    
    func finish() {

    }
    
}
