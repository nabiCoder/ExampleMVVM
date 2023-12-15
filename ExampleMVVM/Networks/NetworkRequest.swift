//
//  NetworkRequest.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import Foundation

final class NetworkRequest {
    
    static let shared = NetworkRequest()
    
    private init() {}
    
    func getData(id: Int, comletionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        
        URLSession.shared.request(.image(id: id)) { data, _, error in
            
            DispatchQueue.main.async {
                
                if error != nil {
                    comletionHandler(.failure(.urlError))
                } else {
                    guard let data else { return }
                    comletionHandler(.success(data))
                }
            }
        }
    }
}
