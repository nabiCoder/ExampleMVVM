import UIKit

protocol CollectionDataProvider: AnyObject {
    
    var dataSource: [ShortImageData]? { get set }
    var cellDataSource: Observable<[CellViewModel]> { get set }
    
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
}

protocol CollectionDataLoader: AnyObject {
    
    var isLoading: Observable<Bool> { get set }
    
    func fetchImages()
}

protocol CollectionViewModelProtocol: CollectionDataProvider, CollectionDataLoader {
    
    var isError: Observable<NetworkError> { get set }
}

final class CollectionViewModel: CollectionViewModelProtocol {
    
    private var imageCacheService: ImageCacheService
    private var imageIdArray: [Int]?
    
    // MARK: - Initialization
    
    init(_ imageCacheService: ImageCacheService,_ imageIdArray: [Int]) {
        self.imageIdArray = imageIdArray
        self.imageCacheService = imageCacheService
    }
    
    // MARK: - Properties
    
    var isLoading: Observable<Bool> = Observable(value: false)
    var dataSource: [ShortImageData]?
    var cellDataSource: Observable<[CellViewModel]> = Observable(value: [])
    var isError: Observable<NetworkError> = Observable(value: nil)
    
    // MARK: - CollectionDataProvider
    
    func numberOfSections() -> Int { 1 }
    
    func numberOfRows(in section: Int) -> Int { cellDataSource.value?.count ?? 0 }
    
    // MARK: - CollectionDataLoader
    
    func fetchImages() {
        
        isLoading.value = true
        
        var images = [ShortImageData]()
        var fetchError: NetworkError?
        let group = DispatchGroup()
        let lock = NSLock()
        
        imageIdArray?.forEach { id in
            group.enter()
            
            imageCacheService.checkAndLoadImageForID(id) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let shortImageData):
                    lock.withLock { images.append(shortImageData) }
                    group.leave()
                case .failure(let error):
                    fetchError = error
                    group.leave()
                case .none:
                    self.fetchImageData(id: id) { imageResult in
                        if let imageResult = imageResult {
                            lock.withLock { images.append(imageResult) }
                            self.imageCacheService.saveImageToCache(imageResult.image, forKey: String(id))
                            group.leave()
                        }
                    }
                }
            }
        }
        group.notify(queue: .main) {
            self.handleFetchCompletion(images: images, error: fetchError)
        }
    }
    
    // MARK: - Private Method
    
    private func fetchImageData(id: Int, completion: @escaping (ShortImageData?) -> Void) {
        NetworkDataFetch.shared.fetchImage(id: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.imageCacheService.loadImageFromURL(data, String(id)) { imageResult in
                    
                    switch imageResult {
                    case .success(let result):
                        completion(result)
                    case .failure(_):
                        completion(nil)
                    }
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    private func handleFetchCompletion(images: [ShortImageData], error: NetworkError?) {
        isLoading.value = false
        
        if let error = error {
            isError.value = error
        } else {
            dataSource = images
            cellDataSource.value = images.compactMap({ CellViewModel($0) })
        }
    }
}
