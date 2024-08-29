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

    private let repository: Repository? = ServiceLocator.shared.resolve()

    init(parentCoordinator: Coordinator, navController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navController = navController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(
            identifier: String(describing: MainViewController.self)
        ) as? MainViewController {
            vc.coordinator = self
            vc.viewModel = MainViewModel(repository: repository)
            navController.pushViewController(vc, animated: true)
        }
    }

    func showDetail(id: Int) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        if let vc = storyboard.instantiateViewController(
            identifier: String(describing: DetailViewController.self)
        ) as? DetailViewController {
            let viewModel = DetailViewModel(repository: repository)
            viewModel.loadMovie(by: id)
            vc.viewModel = viewModel
            navController.pushViewController(vc, animated: true)
        }
    }

    func childDidFinish(_ child: any Coordinator) {

    }

    func finish() {
        for coordinator in childCoordinators {
            coordinator.finish()
        }
        parentCoordinator?.childDidFinish(self)
    }
    

}
