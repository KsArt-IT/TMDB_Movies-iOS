//
//  AppCoordinator.swift
//  TMDB_Movies
//
//  Created by KsArT on 29.08.2024.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let navController: UINavigationController
    private let component: RootComponent

    weak var parentCoordinator: Coordinator? = nil

    var childCoordinators: [Coordinator] = []

    init(navController: UINavigationController, component: RootComponent) {
        self.navController = navController
        self.component = component
    }

    func navigation(to route: Route) {
        switch route {
            case .start: startMoviesFlow()
            default: break
        }
    }

    private func startMoviesFlow() {
        let coordinator = MoviesCoordinator(parent: self, navController: navController, component: component)
        add(child: coordinator)
        coordinator.navigation(to: .start)
    }

    func finish() {
        for coordinator in childCoordinators {
            coordinator.finish()
        }
        childCoordinators.removeAll()
    }

    deinit {
        print("AppCoordinator.deinit")
    }
}
