//
//  Coordinator.swift
//  TMDB_Movies
//
//  Created by KsArT on 29.08.2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get }
    var childCoordinators: [Coordinator] { get set }

    func navigation(to route: Route)
    func finish()
}

extension Coordinator {
    func add(child coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func remove(child coordinator: Coordinator) {
        for (index, child) in childCoordinators.enumerated() {
            if child === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    // сообщить родителю что закончил
    func onFinished() {
        parentCoordinator?.remove(child: self)
    }
}

enum Route {
    case root
    case start
    case detail(id: Int)
}
