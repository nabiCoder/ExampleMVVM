//
//  AppCoordinator.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    var moduleFactory: ModuleFactory
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactory) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func start() {
        showMainScreen()
    }
    
    private func showMainScreen() {
        
        let controller = moduleFactory.createMainScreenController()
        
        navigationController.pushViewController(controller, animated: true)
    }
}
