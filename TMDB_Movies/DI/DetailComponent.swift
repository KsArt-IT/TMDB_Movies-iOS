//
//  DetailComponent.swift
//  TMDB_Movies
//
//  Created by KsArT on 04.09.2024.
//

import UIKit
import NeedleFoundation

class DetailComponent: Component<RepositoryDependency> {
    private func viewModel(_ id: Int) -> DetailViewModel {
        .init(repository: dependency.repository, id: id)
    }

    func viewController(by id: Int) -> UIViewController {
        let vc = DetailViewController.create(of: "Detail")
        vc.setViewModel(viewModel(id))
        return vc
    }
}
