import Foundation

final class NetworkDataFetch {
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    private let networkRequest = NetworkRequest.shared
    
    func fetchImageData(id: Int, responce: @escaping (Result<ImageData, NetworkError>) -> Void) {
        networkRequest.getData(id: id) { result in
            
            switch result {
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(ImageData.self, from: data)
                    responce(.success(image))
                } catch _{
                    responce(.failure(.canNotParseData))
                }
                
            case .failure(let error):
                responce(.failure(error))
            }
        }
    }
    
    func loadImage(_ imageURL: String, comletionHandler: @escaping (Result<ShortImageData, NetworkError>) -> Void) {
        networkRequest.getImage(imageURL) { result in
            
            if let result = result {
                comletionHandler(.success(.init(title: "", image: result)))
            } else {
                comletionHandler(.failure(.errorDownloadingImage))
            }
        }
    }
}
