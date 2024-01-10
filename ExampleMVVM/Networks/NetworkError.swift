//
//  NetworkError.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import Foundation

enum NetworkError: String, Error {
    
    case urlError = "Недопустимый URL-адрес"
    case canNotParseData = "Не удалось преобразовать данные"
    case errorDownloadingImage = "Ошибка при загрузке изображения"
    
    var localizedDescription: String {
        return self.rawValue
    }
}
