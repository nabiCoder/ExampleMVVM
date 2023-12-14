//
//  CacheManager.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import UIKit

//let imageCache = NSCache<NSString, UIImage>()
//
//// Функция для загрузки изображения с учетом кеширования
//func loadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
//    // Проверяем, есть ли изображение в кеше
//    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
//        completion(cachedImage)
//    } else {
//        // Если изображения нет в кеше, загружаем его из сети
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let data = data, let image = UIImage(data: data) {
//                // Кешируем загруженное изображение
//                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
//                completion(image)
//            } else {
//                completion(nil)
//            }
//        }.resume()
//    }
//}
//
//// Использование функции для загрузки изображения
//loadImage(with: URL(string: "https://example.com/image.jpg")!) { (image) in
//    if let image = image {
//        // Используем загруженное изображение
//        imageView.image = image
//    } else {
//        // Обработка случая, если изображение не было загружено
//    }
//}
