//
//  AppDelegate.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Регистрация сервисов
        let networkService = NetworkServiceImpl()
        let repository = RepositoryImpl(service: networkService)

        ServiceLocator.shared.register(service: networkService as NetworkService)
        ServiceLocator.shared.register(service: repository as Repository)

        return true
    }
}

