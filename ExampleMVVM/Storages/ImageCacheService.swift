import UIKit
import SDWebImage

typealias ImageResult = Result<ShortImageData, NetworkError>

// MARK: - Protocols

protocol ImageCaching: AnyObject {
    func checkAndLoadImageForID(_ id: Int, completion: @escaping (ImageResult?) -> Void)
}

protocol ImageCachable {
    func getCachedImage(_ key: String) -> UIImage?
    func saveImageToCache(_ image: UIImage, forKey key: String)
}

// MARK: - ImageCacheService class

final class ImageCacheService {
    private let userDefaults = UserDefaults.standard
    private let lastUpdateKey = "LastUpdate"
    private let updateInterval: TimeInterval = 60
}

// MARK: - LoadImage method

extension ImageCacheService: ImageCaching {
    
    func checkAndLoadImageForID(_ id: Int, completion: @escaping (ImageResult?) -> Void) {
        
        let key = String(id)
        
        guard let lastUpdateDate = userDefaults.object(forKey: lastUpdateKey) as? Date,
              Date().timeIntervalSince(lastUpdateDate) < updateInterval,
              let cachedImage = getCachedImage(key) else { 
            completion(nil)
            return
        }
        completion(.success(ShortImageData(title: key, image: cachedImage)))
    }
}

// MARK: - LoadCachedImage, StoreImage methods

extension ImageCacheService: ImageCachable {
    
    func getCachedImage(_ key: String) -> UIImage? {
        return SDImageCache.shared.imageFromDiskCache(forKey: key)
    }
    
    func saveImageToCache(_ image: UIImage,forKey key: String) {
        SDImageCache.shared.store(image, forKey: key, toDisk: true)
    }
}

// MARK: - DownloadAndCacheImage method

extension ImageCacheService {
    
    func loadImageFromURL(_ imageData: ImageData,
                          _ key: String,
                          completion: @escaping (ImageResult) -> Void) {
        
        guard let imageURL = URL(string: imageData.url) else {
            completion(.failure(.canNotParseData))
            return
        }
        
        SDWebImageManager.shared.loadImage(with: imageURL,
                                           options: .highPriority,
                                           progress: nil) { downloadedImage, _, _, _, _, _ in
            guard let downloadedImage = downloadedImage else {
                completion(.failure(.errorDownloadingImage))
                return
            }
            
            self.userDefaults.set(Date(), forKey: self.lastUpdateKey)
            
            completion(.success(ShortImageData(title: imageData.title, image: downloadedImage)))
        }
    }
}
