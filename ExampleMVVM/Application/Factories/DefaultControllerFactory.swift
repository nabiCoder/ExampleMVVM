//
//  ModuleFactory.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import Foundation

final class DefaultControllerFactory {
    
    func createMainScreenController(_ viewModel: CollectionViewModel) -> CollectionViewController {
        
        CollectionViewController(viewModel)
    }
    
    func createDetailViewController(_ viewModel: DetailViewModel) -> DetailViewController {
        
        DetailViewController(viewModel)
    }
}
