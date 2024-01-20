import UIKit

protocol CellViewModelProtocol: AnyObject {
    var image: UIImage { get }
    var title: String { get }
}

class CellViewModel: CellViewModelProtocol {
    let image: UIImage
    let title: String
    
    init(_ imageData: ShortImageData) {
        self.image = imageData.image
        self.title = imageData.title
    }
}
