import UIKit

extension UIActivityViewController {
    
    convenience init(activityItems: [Any]) {
        self.init(activityItems: activityItems, applicationActivities: nil)
    }
    
    func present(from viewController: UIViewController) {
        viewController.present(self, animated: true, completion: nil)
    }
}
