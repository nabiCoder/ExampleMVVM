import UIKit
import SDWebImage

typealias ImageResult = Result<ShortImageData, NetworkError>

// MARK: - Protocols

protocol ImageCaching: AnyObject {
    func checkAndLoadImageForID(_ id: Int, completion: @escaping (ImageResult?) -> Void)
}

protocol ImageCachable {
    func getCachedImage(_ id: Int, completion: @escaping (ShortImageData?) -> Void)
    func saveImageToCache(_ image: UIImage, forKey key: String)
}

// MARK: - ImageCacheService class

final class ImageCacheService {
    private let userDefaults = UserDefaults.standard
    private let imageCache = SDImageCache.shared
    private let imageManager = SDWebImageManager.shared
    private let lastUpdateKey = "LastUpdate"
    private let updateInterval: TimeInterval = 60
    private let date = Date()
}

// MARK: - checkAndLoadImageForID method

extension ImageCacheService: ImageCaching {
    
    func checkAndLoadImageForID(_ id: Int, completion: @escaping (ImageResult?) -> Void) {
        
        let key = String(id)
         
//        let cachedImage = getCachedImage(key)
        
//        completion(.success(ShortImageData(title: key, image: cachedImage)))
    }
}

// MARK: - getCachedImage, saveImageToCache methods

extension ImageCacheService: ImageCachable {
    
    func getCachedImage(_ id: Int, completion: @escaping (ShortImageData?) -> Void) {
        let key = String(id)
        
        if let cashedImage = imageCache.imageFromDiskCache(forKey: key) {
            completion((.init(title: String(id), image: cashedImage)))
        } else {
            completion(nil)
        }
    }
    
    func saveImageToCache(_ image: UIImage,forKey key: String) {
        imageCache.store(image, forKey: key, toDisk: true)
    }
}

// MARK: - loadImageFromURL method

extension ImageCacheService {
    
    func loadImageFromURL(_ imageData: ImageData,
                          _ key: String,
                          completion: @escaping (ImageResult) -> Void) {
        
        guard let imageURL = URL(string: imageData.url) else {
            completion(.failure(.canNotParseData))
            return
        }
        
        imageManager.loadImage(with: imageURL,
                               options: .highPriority,
                               progress: nil) { [weak self] downloadedImage, _, _, _, _, _ in
            guard let downloadedImage = downloadedImage, let self = self else {
                completion(.failure(.errorDownloadingImage))
                return
            }
            
            self.userDefaults.set(self.date, forKey: self.lastUpdateKey)
            
            completion(.success(.init(title: imageData.title, image: downloadedImage)))
        }
    }
}
