//
//  CellViewModel.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import UIKit

protocol CellViewModelProtocol: AnyObject {
    var image: String { get }
    var title: String { get }
}

class CellViewModel: CellViewModelProtocol {
    
    var image: String
    
    var title: String
    
    init(_ imageData: ImageData) {
        self.image = imageData.url
        self.title = imageData.title
    }
}
