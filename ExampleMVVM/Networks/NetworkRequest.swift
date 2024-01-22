import Foundation
import UIKit

final class NetworkRequest {
    static let shared = NetworkRequest()
    
    private init() {}
    
    func getData(id: Int, comletionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        URLSession.shared.request(.image(id: id)) { data, _, error in
            
            DispatchQueue.main.async {
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        print("Отсутствует интернет-соединение")
                        comletionHandler(.failure(.noInternetConnection))
                    case .networkConnectionLost:
                        print("Потеряно соединение с сетью")
                        comletionHandler(.failure(.urlError))
                    case .timedOut:
                        print("Таймаут запроса")
                    default:
                        print("Другая ошибка сети: \(urlError)")
                    }
                } else {
                    guard let data else { return }
                    comletionHandler(.success(data))
                }
            }
        }
    }
    
    func getImage(_ imageURL: String, comletionHandler: @escaping (UIImage?) -> Void) {
        if let url = URL(string: imageURL) {
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    comletionHandler((image))
                } else {
                    comletionHandler(nil)
                }
            }.resume()
        } else {
            comletionHandler(nil)
        }
    }
}
