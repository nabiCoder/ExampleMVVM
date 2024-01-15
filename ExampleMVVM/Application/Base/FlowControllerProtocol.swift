import Foundation

protocol FlowControllerProtocol {
    
    associatedtype T
    
    var completionHandler: ((T) -> (Void))? { get }
}
