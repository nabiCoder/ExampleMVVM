//
//  NetworkDataFetch.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import Foundation

final class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    func fetchImage(id: Int, responce: @escaping (Result<ImageData, NetworkError>) -> Void) {
        
        NetworkRequest.shared.getData(id: id) { result in
            
            switch result {
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(ImageData.self, from: data)
                    
                    responce(.success(image))
//                    можно проверить алерт об ошибке раскомментировав код ниже
//                    responce(.failure(.canNotPareData))
                } catch _{
                    
                    responce(.failure(.canNotParseData))
                }
            case .failure(_):
                
                responce(.failure(.urlError))
            }
        }
    }
}
