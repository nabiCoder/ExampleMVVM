//
//  NetworkError.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import Foundation

enum NetworkError: String, Error {
    
    case urlError = "Invalid URL"
    case canNotPareData = "Failed to parse data"
    case errorDownloadingImage = "Error downloading image"
    
    var localizedDescription: String {
        return self.rawValue
    }
}
