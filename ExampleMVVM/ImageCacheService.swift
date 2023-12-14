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

class ImageCacheService: ImageCaching {
    
    private let cache = NSCache<NSNumber, ImageDataWrapper>()
    
    func loadImage(with id: Int, completion: @escaping (ShortImageData?) -> Void) {
        let key = NSNumber(value: id)
        
        if let cachedObject = cache.object(forKey: key) {
            let url = cachedObject.imageData.url
            let title = cachedObject.imageData.title
            
            completion(ShortImageData(title: title, url: url))
        } else { 
            NetworkDataFetch.shared.fetchImage(id: id) { [weak self] image, error in
                guard let self = self else { return }
                
                if let image = image {
                    
                    guard let url = URL(string: image.url) else { return }
                    let title = image.title
                    
                    let imageData = ShortImageData(title: title, url: url)
                    let imageDataWrapper = ImageDataWrapper(imageData)
                    self.cache.setObject(imageDataWrapper, forKey: key)
                    
                    // Создаем ShortImageData
                    let shortImageData = ShortImageData(title: imageData.title, url: imageData.url)
                    completion(shortImageData)
                } else {
                    // Обработка ошибки загрузки изображения
                    print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                }
            }
        }
    }
}

