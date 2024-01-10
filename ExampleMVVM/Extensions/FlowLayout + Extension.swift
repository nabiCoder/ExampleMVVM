//
//  FlowLayout + Extension.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 15.12.2023.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    func calculateCollectionViewLayout() -> UICollectionViewFlowLayout {
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth: CGFloat = screenWidth / 2 - 30
        let itemSize = CGSize(width: itemWidth, height: itemWidth)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.sectionInset.left = 15
        layout.sectionInset.right = 15

        return layout
    }
}
