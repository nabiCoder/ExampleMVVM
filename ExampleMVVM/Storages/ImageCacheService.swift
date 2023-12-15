//
//  ImageCacheService.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 15.12.2023.
//

import UIKit

protocol ImageCaching {
    
    func loadImage(with id: Int, completion: @escaping (ShortImageData?) -> Void)
}

final class ImageCacheService: ImageCaching {
    
    private let cache = NSCache<NSNumber, ImageDataWrapper>()
    
    func loadImage(with id: Int, completion: @escaping (ShortImageData?) -> Void) {
        let key = NSNumber(value: id)
        
        if let cachedObject = cache.object(forKey: key) {
            let image = cachedObject.imageData.image
            let title = cachedObject.imageData.title
            
            completion(ShortImageData(title: title, image: image))
        } else {
            NetworkDataFetch.shared.fetchImage(id: id) { [weak self] image, error in
                guard let self = self else { return }
                
                if let image = image {
                    
                    guard let url = URL(string: image.url) else { return }
                    let title = image.title
                    self.downloadImage(url: url) { downloadedImage in
                        guard let downloadedImage = downloadedImage else {
                            print("Error downloading image")
                            completion(nil)
                            return
                        }
                        
                        let imageData = ShortImageData(title: title, image: downloadedImage)
                        let imageDataWrapper = ImageDataWrapper(imageData)
                        self.cache.setObject(imageDataWrapper, forKey: key)
                        
                        let shortImageData = ShortImageData(title: imageData.title, image: imageData.image)
                        completion(shortImageData)
                    }
                } else {
                    print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                }
            }
        }
    }
    private func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }
        task.resume()
    }
}

