//
//  CollectionViewCell.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "Cell"
    
    lazy var customLayer: CALayer = {
        
        let layer = CALayer()
        layer.contentsGravity = .resizeAspect
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.addSublayer(customLayer)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configureCell(_ viewModel: CellViewModel) {
        
        customLayer.contents = viewModel.image.cgImage
    }
}

private extension CollectionViewCell {
    
    private func setupConstraints() {
        customLayer.frame = contentView.bounds
    }
}
