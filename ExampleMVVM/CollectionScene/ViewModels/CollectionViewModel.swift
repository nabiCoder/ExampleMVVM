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
    var isLoading: Observable<Bool> { get set }
    var dataSource: [ShortImageData]? { get set }
    var cellDataSource: Observable<[CellViewModel]> { get set }
}

class CollectionViewModel: CollectionViewModelProtocol {
    
    private var imageCacheService: ImageCacheService
    
    init(_ imageCacheService: ImageCacheService) {
        self.imageCacheService = imageCacheService
    }
   
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int) -> Int {
        cellDataSource.value?.count ?? 0
    }
    
    var isLoading: Observable<Bool> = Observable(value: false)
    var dataSource: [ShortImageData]?
    var cellDataSource: Observable<[CellViewModel]> = Observable(value: nil)
    
    func fetchImages() {
        isLoading.value = true
        
        let imageId = [1, 2, 3, 4, 5, 6, 7]
        var images = [ShortImageData]()
        let group = DispatchGroup()
        
        imageId.forEach {
            group.enter()
            imageCacheService.loadImage(with: $0) { shortImageData in
                guard let shortImageData else { return }
                
                images.append(shortImageData)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isLoading.value = false
            self.dataSource = images
            self.cellDataSource.value = images.compactMap({ CellViewModel($0) })
        }
    }
}
