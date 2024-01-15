import UIKit

extension DetailViewController {
    
    func createShareButton() {
        
        shareButton = navigationController?.shareButton(target: self,
                                                        action: #selector(shareButtonTapped))
    }
    
    func setupNavItem() {
        
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc func shareButtonTapped() {
        
        viewModel?.shareImage(from: self) { }
    }
    
    func setupView() {
        
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
