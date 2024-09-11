//
//  SceneDelegate.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit
class DependencyManager {
    static func createSearchNC() -> UIViewController {
        let presenter = MainPresenter()
        let searchVC = MainViewController(presenter: presenter)
        searchVC.title = "ImageSearcher"
        return searchVC
    }

    static func createNavController() -> UINavigationController {
        let navController = UINavigationController()
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : Constants.Colors.mainTextColor
            ]
            navigationBarAppearance.backgroundColor = Constants.Colors.backgroungColor
            UINavigationBar.appearance().standardAppearance   = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance    = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        navController.viewControllers = [createSearchNC()]
        return navController
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = DependencyManager.createNavController()
        window?.makeKeyAndVisible()
    }
}

