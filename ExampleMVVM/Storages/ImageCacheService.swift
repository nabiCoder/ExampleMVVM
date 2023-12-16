//
//  ImageCacheService.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 15.12.2023.
//

import UIKit
import SDWebImage

protocol ImageCaching {
    
    func loadImage(with id: Int, completion: @escaping (ShortImageData?) -> Void)
}

final class ImageCacheService: ImageCaching {
    
    func loadImage(with id: Int, completion: @escaping (ShortImageData?) -> Void) {
        
        let key = String(id)
        
        if let cachedImage = loadCachedImage(forKey: key) {
            
            completion(ShortImageData(title: key, image: cachedImage))
        } else {
            
            fetchAndCacheImage(id: id, key: key, completion: completion)
        }
    }
    
    private func loadCachedImage(forKey key: String) -> UIImage? {
        
        return SDImageCache.shared.imageFromDiskCache(forKey: key)
    }
    
    private func fetchAndCacheImage(id: Int, key: String, completion: @escaping (ShortImageData?) -> Void) {
        
        NetworkDataFetch.shared.fetchImage(id: id) { [unowned self] image, error in
            
            guard let image = image, error == nil else {
                print("Error loading image:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                
                return
            }
            
            self.downloadAndCacheImage(image: image, key: key, completion: completion)
        }
    }
    
    private func downloadAndCacheImage(image: ImageData,
                                       key: String,
                                       completion: @escaping (ShortImageData?) -> Void) {
        guard let imageURL = URL(string: image.url) else {
            print("Error loading image: Invalid URL")
            completion(nil)
            
            return
        }
        
        SDWebImageManager.shared.loadImage(with: imageURL, 
                                           options: .highPriority,
                                           progress: nil) { downloadedImage, _, _, _, _, _ in
            guard let downloadedImage = downloadedImage else {
                print("Error downloading image")
                completion(nil)
                
                return
            }
            
            SDImageCache.shared.store(downloadedImage, forKey: key, toDisk: true)
            
            completion(ShortImageData(title: image.title, image: downloadedImage))
        }
    }
}
