//
//  ImageCacheService.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 15.12.2023.
//

import UIKit
import SDWebImage

typealias ImageResult = Result<ShortImageData, NetworkError>

protocol ImageCaching {
    
    func loadImage(with id: Int, completion: @escaping (Result<ShortImageData, NetworkError>) -> Void)
}

final class ImageCacheService: ImageCaching {
    
    func loadImage(with id: Int, completion: @escaping (ImageResult) -> Void) {
        
        let key = String(id)
        
        if let cachedImage = loadCachedImage(forKey: key) {
            
            completion(.success(ShortImageData(title: key, image: cachedImage)))
        } else {
            
            fetchAndCacheImage(id: id, key: key, completion: completion)
        }
    }
    
    private func loadCachedImage(forKey key: String) -> UIImage? {
        
        return SDImageCache.shared.imageFromDiskCache(forKey: key)
    }
    
    private func fetchAndCacheImage(id: Int,
                                    key: String,
                                    completion: @escaping (ImageResult) -> Void) {
        
        NetworkDataFetch.shared.fetchImage(id: id) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                
                self.downloadAndCacheImage(image: data, key: key, completion: completion)
            case .failure(let error):
                
                completion(.failure(error))
            }
        }
    }
    
    private func downloadAndCacheImage(image: ImageData,
                                       key: String,
                                       completion: @escaping (ImageResult) -> Void) {
        guard let imageURL = URL(string: image.url) else {
            print("Error loading image: Invalid URL")
            completion(.failure(.canNotPareData))
            
            return
        }
        
        SDWebImageManager.shared.loadImage(with: imageURL,
                                           options: .highPriority,
                                           progress: nil) { downloadedImage, _, _, _, _, _ in
            guard let downloadedImage = downloadedImage else {
                print("Error downloading image")
                completion(.failure(.errorDownloadingImage))
                
                return
            }
            
            SDImageCache.shared.store(downloadedImage, forKey: key, toDisk: true)
            
            completion(.success(ShortImageData(title: image.title, image: downloadedImage)))
        }
    }
}
