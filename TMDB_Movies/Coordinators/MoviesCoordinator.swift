//
//  MoviesCoordinator.swift
//  TMDB_Movies
//
//  Created by KsArT on 29.08.2024.
//

import UIKit

final class MoviesCoordinator: Coordinator {

    private let navController: UINavigationController

    weak var parentCoordinator: Coordinator?

    var childCoordinators: [Coordinator] = []

    private var repository: Repository?

    init(parent coordinator: Coordinator, navController: UINavigationController) {
        self.parentCoordinator = coordinator
        self.navController = navController

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
        let vc = MainViewController.create(of: "Main")
        vc.setViewModel(MainViewModel(coordinator: self, repository: repository))
        navController.pushViewController(vc, animated: true)
    }

    private func showDetail(id: Int) {
        let vc = DetailViewController.create(of: "Detail")
        vc.viewModel = DetailViewModel(repository: repository)
        vc.viewModel.loadMovie(by: id)
        navController.pushViewController(vc, animated: true)
    }

    func finish() {
        navController.viewControllers.removeAll()
        repository = nil
        onFinished(child: self)
    }

    deinit {
        print("MoviesCoordinator.deinit")
    }

}
