//
//  NavigationController + Extension.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 15.12.2023.
//

import UIKit

extension UINavigationController {
    
    func shareButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        
        let shareButton = UIBarButtonItem( barButtonSystemItem: .action,
                                           target: target,
                                           action: action
        )
    
        return shareButton
    }
}
