//
//  DefaultViewModelFactory.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import Foundation

class DefaultViewModelFactory {
    
    func createMainViewModel(_ imageCacheService: ImageCacheService) -> CollectionViewModel {
        
        CollectionViewModel(imageCacheService)
    }
    
    func createDetailViewModel() -> DetailViewModel {
        
        DetailViewModel()
    }
}
