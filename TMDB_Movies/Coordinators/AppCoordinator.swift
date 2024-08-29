//
//  AppCoordinator.swift
//  TMDB_Movies
//
//  Created by KsArT on 29.08.2024.
//

import UIKit

final class AppCoordinator: Coordinator {

    var navController: UINavigationController
    
    weak var parentCoordinator: Coordinator? = nil

    var childCoordinators: [Coordinator] = []

    init(navController: UINavigationController) {
        self.navController = navController
    }

    func start() {
        startMoviesFlow()
    }

    private func startMoviesFlow() {
        let coordinator = MoviesCoordinator(parentCoordinator: self, navController: navController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    // MARK: - deinitialize
    func childDidFinish(_ child: any Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    func finish() {
        print("AppCoordinator.deinit")
        for coordinator in childCoordinators {
            coordinator.finish()
        }
        childCoordinators.removeAll()
    }

    deinit {
        print("AppCoordinator.deinit")
    }
}
