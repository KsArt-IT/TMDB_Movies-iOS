//
//  AppDelegate.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import UIKit
import NeedleFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Выполнить сгенерированный код Neddle генератором
        // needle generate TMDB_Movies/DI/NeedleGenerated.swift TMDB_Movies/
        registerProviderFactories()

        return true
    }
}

