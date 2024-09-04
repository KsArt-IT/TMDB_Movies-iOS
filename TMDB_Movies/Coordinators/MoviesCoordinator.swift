//
//  MoviesCoordinator.swift
//  TMDB_Movies
//
//  Created by KsArT on 29.08.2024.
//

import UIKit

final class MoviesCoordinator: Coordinator {

    private let navController: UINavigationController
    private let component: RootComponent

    weak var parentCoordinator: Coordinator?

    var childCoordinators: [Coordinator] = []

    private var repository: Repository?

    init(parent coordinator: Coordinator, navController: UINavigationController, component: RootComponent) {
        self.parentCoordinator = coordinator
        self.navController = navController
        self.component = component

        initRepository()
    }

    func navigation(to route: Route) {
        switch route {
            case .start: showMain()
            case .detail(let id): showDetail(id: id)
            default: break
        }
    }

    private func initRepository() {
        let networkService = NetworkServiceImpl()
        repository = RepositoryImpl(service: networkService)
    }

    private func showMain() {
        let vc = component.mainComponent.viewController(coordinator: self)
        navController.pushViewController(vc, animated: true)
    }

    private func showDetail(id: Int) {
        let vc = component.detailComponent.viewController(by: id)
        navController.pushViewController(vc, animated: true)
    }

    func finish() {
        navController.viewControllers.removeAll()
        repository = nil
        onFinished()
    }

    deinit {
        print("MoviesCoordinator.deinit")
    }

}
