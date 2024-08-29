//
//  MoviesCoordinator.swift
//  TMDB_Movies
//
//  Created by KsArT on 29.08.2024.
//

import UIKit

final class MoviesCoordinator: Coordinator {

    weak var parentCoordinator: Coordinator?

    var navController: UINavigationController

    var childCoordinators: [Coordinator] = []

    private var repository: Repository?

    init(parentCoordinator: Coordinator, navController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navController = navController
    }
    
    func start() {
        initRepository()
        showMain()
    }

    private func initRepository() {
        let networkService = NetworkServiceImpl()
        repository = RepositoryImpl(service: networkService)
    }

    private func showMain() {
        let vc = MainViewController.create(of: "Main")
        vc.coordinator = self
        vc.viewModel = MainViewModel(repository: repository)
        navController.pushViewController(vc, animated: true)
    }

    func showDetail(id: Int) {
        let vc = DetailViewController.create(of: "Detail")
        vc.viewModel = DetailViewModel(repository: repository)
        vc.viewModel.loadMovie(by: id)
        navController.pushViewController(vc, animated: true)
    }

    func childDidFinish(_ child: any Coordinator) {

    }

    func finish() {
        navController.viewControllers.removeAll()
        repository = nil
        parentCoordinator?.childDidFinish(self)
    }

    deinit {
        print("MoviesCoordinator.deinit")
    }

}
