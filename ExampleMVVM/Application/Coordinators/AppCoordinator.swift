//
//  AppCoordinator.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    let controllerFactory = DefaultControllerFactory()
    let viewModelFactory = DefaultViewModelFactory()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMainScreen()
    }
    
    private func showMainScreen() {
        
        let imageCacheService = ImageCacheService()
        
        let viewModel = viewModelFactory.createMainViewModel(imageCacheService)
        
        let controller = controllerFactory.createMainScreenController(viewModel)
        controller.completionHandler = { [weak self] value in
            print(value)
            self?.showDetailScreen(value)
        }
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func showDetailScreen(_ shortImageData: ShortImageData) {
        
        let viewModel = viewModelFactory.createDetailViewModel(shortImageData)
        
        let controller = controllerFactory.createDetailViewController(viewModel)
        
        navigationController.pushViewController(controller, animated: true)
    }
}
