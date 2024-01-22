import UIKit

final class AppCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    private let controllerFactory = DefaultControllerFactory()
    private let viewModelFactory = DefaultViewModelFactory()
    private let imageCacheService: ImageCacheService
    private let imageIdArray = Array(1...10)
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController, imageCacheService: ImageCacheService) {
        self.navigationController = navigationController
        self.imageCacheService = imageCacheService
    }
    
    func start() {
        showMainScreen()
    }
    
    private func showMainScreen() {
        
        let viewModel = viewModelFactory.createMainViewModel(imageCacheService, imageIdArray)
        let controller = controllerFactory.createMainScreenController(viewModel)
        
        controller.completionHandler = { [weak self] value in
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
