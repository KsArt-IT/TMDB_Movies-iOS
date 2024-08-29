//
//  ViewControllerCreator.swift
//  TMDB_Movies
//
//  Created by KsArT on 29.08.2024.
//

import UIKit

protocol ViewControllerCreator {
    static func create(of storyboardName: String) -> Self
}

extension ViewControllerCreator where Self: UIViewController {
    static func create(of storyboardName: String) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(identifier: id) as! Self
    }
}
