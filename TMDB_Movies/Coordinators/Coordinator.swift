//
//  Coordinator.swift
//  TMDB_Movies
//
//  Created by KsArT on 29.08.2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var navController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
    func childDidFinish(_ child: Coordinator)
}

