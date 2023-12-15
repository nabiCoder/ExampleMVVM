//
//  SceneDelegate.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
   
    var coordinator = AppCoordinator(navigationController: UINavigationController(), 
                                     imageCacheService: ImageCacheService())

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = coordinator.navigationController
        
        coordinator.start()
        
        window?.makeKeyAndVisible()
    }
}
