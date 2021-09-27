import Foundation

@testable import Networking

extension ApiClientProtocol where Self == ApiClientStub {
    
    static func success(stub: String) -> ApiClientProtocol {
        ApiClientStub(file: stub)
    }
    
    static func failure(_ error: Error) -> ApiClientProtocol {
        ApiClientStub(error: error)
    }
}
