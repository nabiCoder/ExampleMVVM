import Foundation

final class DefaultViewModelFactory {
    
    func createMainViewModel(_ imageCacheService: ImageCacheService,
                             _ imageIdArray: [Int]) -> CollectionViewModel {
        CollectionViewModel(imageCacheService, imageIdArray)
    }
    
    func createDetailViewModel(_ shortImageData: ShortImageData) -> DetailViewModel {
        DetailViewModel(cellDataSource: shortImageData)
    }
}
