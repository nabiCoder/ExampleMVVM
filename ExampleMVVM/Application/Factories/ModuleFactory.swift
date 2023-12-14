//
//  ModuleFactory.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import Foundation

class ModuleFactory {
    
    func createMainScreenController() -> CollectionViewController {
        CollectionViewController()
    }
    
    func createDetailViewController() -> DetailViewController {
        DetailViewController()
    }
}
