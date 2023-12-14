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
            self?.showDetailScreen(value)
        }
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func showDetailScreen(_ data: ShortImageData) {
        
        let controller = controllerFactory.createDetailViewController(data)
        //controller.viewModel = viewModelFactory.createDetailViewModel()
        
        navigationController.pushViewController(controller, animated: true)
    }
}
