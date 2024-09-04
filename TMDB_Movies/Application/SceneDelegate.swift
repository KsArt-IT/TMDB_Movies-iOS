//
//  SceneDelegate.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let navController = UINavigationController()
        appCoordinator = AppCoordinator(navController: navController)
        appCoordinator?.navigation(to: .start)

        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Вызывается, когда сцена отключается. Можно освободить ресурсы.
        print("SceneDelegate.deinit")
        appCoordinator?.finish()
        appCoordinator = nil
    }

}

