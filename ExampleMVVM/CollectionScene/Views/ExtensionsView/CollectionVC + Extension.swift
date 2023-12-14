//
//  CollectionVC + Extension.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import Foundation
import UIKit

extension CollectionViewController {
    
    func reloadCollectionView() {
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupCollection() {
        
        collectionView.backgroundColor = .white
        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        (viewModel?.numberOfSections())!
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        (viewModel?.numberOfRows(in: section))!
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier,
                                                            for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let cellViewModel = cellDataSourse[indexPath.item]
        cell.configureCell(cellViewModel)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let shortImageData = viewModel?.dataSource else { return }
        print(shortImageData)
        completionHandler!(shortImageData[indexPath.item])
    }
}

