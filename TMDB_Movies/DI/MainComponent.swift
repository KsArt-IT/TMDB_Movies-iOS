//
//  MainComponent.swift
//  TMDB_Movies
//
//  Created by KsArT on 04.09.2024.
//

import UIKit
import NeedleFoundation

class MainComponent: Component<RepositoryDependency> {
    private func viewModel(_ coordinator: Coordinator) -> MainViewModel {
        .init(coordinator: coordinator, repository: dependency.repository)
    }

    func viewController(coordinator: Coordinator) -> UIViewController {
        let vc = MainViewController.create(of: "Main")
        vc.setViewModel(viewModel(coordinator))
        return vc
    }
}
