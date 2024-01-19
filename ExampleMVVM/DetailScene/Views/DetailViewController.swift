import UIKit

final class DetailViewController: UIViewController {
    var viewModel: DetailViewModel?
    var shareButton: UIBarButtonItem?
    
    init(_ viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - UI Elements
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        bindViewModel()
        
        createShareButton()
        setupNavItem()
    }
    
    // MARK: - ViewModel Binding
    
    private func bindViewModel() {
        viewModel?.cellDataSource.bind({ [weak self] shortImageData in
            guard let self, let shortImageData else { return }
            
            imageView.image = shortImageData.image
            titleLabel.text = shortImageData.title
        })
    }
}
