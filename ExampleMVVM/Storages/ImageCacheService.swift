//
//  ImageCacheService.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 15.12.2023.
//

import UIKit
import SDWebImage

typealias ImageResult = Result<ShortImageData, NetworkError>

// MARK: - Protocols

protocol ImageCaching: AnyObject {
    
    func loadImage(with id: Int, completion: @escaping (ImageResult) -> Void)
}

protocol ImageCachable {
    
    func loadCachedImage(forKey key: String) -> UIImage?
    func storeImage(_ image: UIImage, forKey key: String)
}

protocol ImageFetcher {
    
    func fetchImage(id: Int, completion: @escaping (ImageResult) -> Void)
}

// MARK: - ImageCacheService class

final class ImageCacheService {
    
    private let userDefaults = UserDefaults.standard
    private let lastUpdateKey = "LastUpdate"
    private let updateInterval: TimeInterval = 60
}

// MARK: - LoadImage method

extension ImageCacheService: ImageCaching {
    
    func loadImage(with id: Int,
                   completion: @escaping (ImageResult) -> Void) {
        
        let key = String(id)
        
        guard let lastUpdateDate = userDefaults.object(forKey: lastUpdateKey) as? Date,
              Date().timeIntervalSince(lastUpdateDate) < updateInterval,
              let cachedImage = loadCachedImage(forKey: key) else {
            
            fetchImage(id: id, completion: completion)
            
            return
        }
        
        completion(.success(ShortImageData(title: key,
                                           image: cachedImage)))
    }
}

// MARK: - LoadCachedImage, StoreImage methods

extension ImageCacheService: ImageCachable {
    
    func loadCachedImage(forKey key: String) -> UIImage? {
        
        return SDImageCache.shared.imageFromDiskCache(forKey: key)
    }
    
    func storeImage(_ image: UIImage,
                    forKey key: String) {
        
        SDImageCache.shared.store(image, forKey: key, toDisk: true)
    }
}

// MARK: - FetchImage method

extension ImageCacheService: ImageFetcher {
    
    func fetchImage(id: Int,
                    completion: @escaping (ImageResult) -> Void) {
        
        NetworkDataFetch.shared.fetchImage(id: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                
                self.downloadAndCacheImage(image: data,
                                           key: String(id),
                                           completion: completion)
            case .failure(let error):
                
                completion(.failure(error))
            }
        }
    }
}

// MARK: - DownloadAndCacheImage method

private extension ImageCacheService {
    
    func downloadAndCacheImage(image: ImageData,
                               key: String,
                               completion: @escaping (ImageResult) -> Void) {
        
        guard let imageURL = URL(string: image.url) else {
            
            completion(.failure(.canNotPareData))
            
            return
        }
        
        SDWebImageManager.shared.loadImage(with: imageURL,
                                           options: .highPriority,
                                           progress: nil) { downloadedImage, _, _, _, _, _ in
            guard let downloadedImage = downloadedImage else {
                
                completion(.failure(.errorDownloadingImage))
                
                return
            }
            
            self.storeImage(downloadedImage, forKey: key)
            self.userDefaults.set(Date(), forKey: self.lastUpdateKey)
            
            completion(.success(ShortImageData(title: image.title,
                                               image: downloadedImage)))
        }
    }
}
