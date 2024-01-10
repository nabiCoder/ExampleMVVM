//
//  DetailViewModel.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import UIKit

protocol ViewModelDataSource: AnyObject {
    
    var dataSource: ShortImageData? { get set }
    var cellDataSource: Observable<ShortImageData> { get set }
}

final class DetailViewModel: ViewModelDataSource {
    
    private var image: UIImage?
    
    var dataSource: ShortImageData?
    var cellDataSource: Observable<ShortImageData> = Observable(value: nil)
    
    init(cellDataSource: ShortImageData) {
        
        self.dataSource = cellDataSource
        self.image = cellDataSource.image
        
        updateCellDataSource()
    }
    
    private func updateCellDataSource() {
        
        cellDataSource.value = dataSource
    }
    
    func shareImage(from viewController: UIViewController, completion: @escaping () -> Void) {
        
            guard let image = image else { return }

            let shareController = UIActivityViewController(activityItems: [image], 
                                                           applicationActivities: nil)
        
            viewController.present(shareController, animated: true) {
                completion()
        }
    }
}
