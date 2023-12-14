//
//  CoordinatorProtocol.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    
    var navigationController: UINavigationController { get set }
    
    func start()
}
