import SDWebImage

typealias ImageResult = Result<ShortImageData, NetworkError>

// MARK: - Protocols

protocol ImageCachable {
    func getCachedImage(_ id: Int, completion: @escaping (ShortImageData?) -> Void)
    func saveImageToCache(_ image: UIImage, forKey key: String)
}

// MARK: - ImageCacheService class

final class ImageCacheService {
    private let userDefaults = UserDefaults.standard
    private let imageCache = SDImageCache.shared
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
    
    func saveImageToCache(_ image: UIImage, forKey key: String) {
        imageCache.store(image, forKey: key, toDisk: true)
    }
}
