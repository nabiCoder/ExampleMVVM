//
//  DetailViewModel.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import Foundation

protocol ViewModelDataSource: AnyObject {
    
    var dataSource: ShortImageData? { get set }
    var cellDataSource: Observable<ShortImageData> { get set }
}

class DetailViewModel: ViewModelDataSource {
    var dataSource: ShortImageData?
    
    var cellDataSource: Observable<ShortImageData> = Observable(value: nil)
    
    init(cellDataSource: ShortImageData) {
        self.dataSource = cellDataSource
        fetc()
    }
    
    func fetc() {
        cellDataSource.value = dataSource
    }
}
