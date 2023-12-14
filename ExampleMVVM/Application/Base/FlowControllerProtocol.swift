//
//  FlowControllerProtocol.swift
//  ExampleMVVM
//
//  Created by Денис Набиуллин on 14.12.2023.
//

import Foundation

protocol FlowControllerProtocol {
    
    associatedtype T
    
    var completionHandler: ((T) -> (Void))? { get }
}
