import Foundation

final class DefaultControllerFactory {
    
    func createMainScreenController(_ viewModel: CollectionViewModel) -> CollectionViewController {
        CollectionViewController(viewModel)
    }
    
    func createDetailViewController(_ viewModel: DetailViewModel) -> DetailViewController {
        DetailViewController(viewModel)
    }
}
