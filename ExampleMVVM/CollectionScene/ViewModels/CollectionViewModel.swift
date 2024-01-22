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
    
    private let imageCacheService: ImageCacheService
    private let imageIdArray: [Int]?
    private let placeholderImage = Resources.Images.noImage
    private let networkDataFetch = NetworkDataFetch.shared
    
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
        var images = [ShortImageData]()
        var fetchError: NetworkError?
        let fetchGroup = DispatchGroup()
        let cacheGroup = DispatchGroup()
        
        isLoading.value = true
        cacheGroup.enter()
        
        imageIdArray?.forEach { id in
            fetchGroup.enter()
            
            loadImageFromCacheOrNetwork(id: id) { result in
                defer { fetchGroup.leave() }
                
                switch result {
                case .success(let image):
                    images.append(image)
                    self.imageCacheService.saveImageToCache(image.image, forKey: String(id))
                case .failure(let error):
                    images.append(.init(title: String(id), image: UIImage(named: self.placeholderImage)!))
                    fetchError = error
                }
            }
        }
        
        fetchGroup.notify(queue: .main) {
            cacheGroup.leave()
            cacheGroup.notify(queue: .main) {
                self.handleFetchCompletion(images: images, error: fetchError)
            }
        }
    }
    
    // MARK: - Private Method
    
    private func loadImageFromCacheOrNetwork(id: Int, 
                                             completion: @escaping (Result<ShortImageData, NetworkError>) -> Void) {
        
        imageCacheService.getCachedImage(id) { cachedResult in
            if let cachedImage = cachedResult {
                completion(.success(cachedImage))
            } else {
                self.networkDataFetch.fetchImageData(id: id) { [weak self] networkResult in
                    guard let self = self else { return }
                    switch networkResult {
                    case .success(let networkImage):
                        let imageURL = networkImage.url
                        self.networkDataFetch.loadImage(imageURL) { result in
                            switch result {
                            case .success(let data):
                                completion(.success(data))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private func handleFetchCompletion(images: [ShortImageData], error: NetworkError?) {
        isLoading.value = false
        isError.value = error
        
        dataSource = images
        cellDataSource.value = images.compactMap({ CellViewModel($0) })
    }
}
