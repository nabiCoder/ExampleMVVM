//
//  CellViewModel.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import UIKit

protocol CellViewModelProtocol: AnyObject {
    
    var image: UIImage { get }
    var title: String { get }
}

class CellViewModel: CellViewModelProtocol {
    
    let image: UIImage
    let title: String
    
    init(_ imageData: ShortImageData) {
        
        self.image = imageData.image
        self.title = imageData.title
    }
}
