//
//  CollectionViewController.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import UIKit

final class CollectionViewController: UICollectionViewController, FlowControllerProtocol {
    
    private let activityIndicator = UIActivityIndicatorView()
    private let layout = UICollectionViewFlowLayout()
    
    var viewModel: CollectionViewModel?
    var completionHandler: ((ShortImageData) -> (Void))?
    var cellDataSourse = [CellViewModel]()
    
    // MARK: - Initialization
    
    init(_ viewModel: CollectionViewModel) {
        
        self.viewModel = viewModel
        super.init(collectionViewLayout: layout.calculateCollectionViewLayout())
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        setupCollection()
        setupConstraints()
        
        viewModel!.fetchImages()
        bindViewModel()
    }
    
    private func setupActivityIndicator() {
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    // MARK: - Binding
    
    private func bindViewModel() {
        
        viewModel?.isLoading.bind({ [weak self] isLoading in
            guard let self, let isLoading else { return }
            
            DispatchQueue.main.async {
                isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
        })
        
        viewModel?.cellDataSource.bind({ [weak self] images in
            guard let self, let images else { return }
            
            cellDataSourse = images
            reloadCollectionView()
        })
    }
}
