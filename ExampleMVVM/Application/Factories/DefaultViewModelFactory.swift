//
//  DefaultViewModelFactory.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import Foundation

final class DefaultViewModelFactory {
    
    func createMainViewModel(_ imageCacheService: ImageCacheService) -> CollectionViewModel {
        
        CollectionViewModel(imageCacheService)
    }
    
    func createDetailViewModel(_ shortImageData: ShortImageData) -> DetailViewModel {
        
        DetailViewModel(cellDataSource: shortImageData)
    }
}
