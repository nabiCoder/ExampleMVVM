//
//  CollectionViewModel.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import UIKit

protocol CollectionDataProvider: AnyObject {
    
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
}

protocol CollectionDataLoader: AnyObject {
    
    var isLoading: Observable<Bool> { get set }
    func fetchImages()
}

protocol CollectionViewModelProtocol: CollectionDataProvider, CollectionDataLoader {
    
    var dataSource: [ShortImageData]? { get set }
    var cellDataSource: Observable<[CellViewModel]> { get set }
    var isError: Observable<NetworkError> { get set }
}

final class CollectionViewModel: CollectionViewModelProtocol {
    
    private var imageCacheService: ImageCacheService
    
    // MARK: - Initialization
    
    init(_ imageCacheService: ImageCacheService) {
        
        self.imageCacheService = imageCacheService
    }
    
    func numberOfSections() -> Int { 1 }
    
    func numberOfRows(in section: Int) -> Int { cellDataSource.value?.count ?? 0 }
    
    var isLoading: Observable<Bool> = Observable(value: false)
    var dataSource: [ShortImageData]?
    var cellDataSource: Observable<[CellViewModel]> = Observable(value: nil)
    var isError: Observable<NetworkError> = Observable(value: nil)
    
    func fetchImages() {
        
        isLoading.value = true
        
        let imageId = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        var images = [ShortImageData]()
        var fetchError: NetworkError?
        let group = DispatchGroup()
        
        imageId.forEach {
            
            group.enter()
            
            imageCacheService.loadImage(with: $0) { result in
                
                switch result {
                case .success(let shortImageData):
                    
                    images.append(shortImageData)
                case .failure(let error):
                    
                    fetchError = error
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            
            self.isLoading.value = false
            
            if let error = fetchError {
                
                self.isError.value = error
            } else {
                
                self.dataSource = images
                self.cellDataSource.value = images.compactMap({ CellViewModel($0) })
            }
        }
    }
}
