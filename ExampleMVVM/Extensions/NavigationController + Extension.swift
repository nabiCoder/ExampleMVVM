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
