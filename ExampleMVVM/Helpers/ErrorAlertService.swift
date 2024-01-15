import UIKit

final class ErrorAlertService {
    
    static let shared = ErrorAlertService()
    
    private init() {}

    func showAlert(on viewController: UIViewController,
                   with error: NetworkError,
                   okHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "Что-то пошло не так", 
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ОК", style: .default){_ in
            okHandler()
        }
        
        alert.addAction(okAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
