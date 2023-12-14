//
//  NetworkDataFetch.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import Foundation

class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    func fetchImage(id: Int, responce: @escaping (Image?, NetworkError?) -> Void) {
        
        NetworkRequest.shared.getData(id: id) { result in
            
            switch result {
                
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(Image.self, from: data)
                    responce(image, nil)
                } catch let jsonError{
                    print(jsonError.localizedDescription)
                }
            case .failure(_):
                responce(nil, .canNotPareData)
            }
        }
    }
}
