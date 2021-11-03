import Foundation
import Combine

extension Decodable {
    
    var justEraseToAnyPublisherWithGenericError: AnyPublisher<Self, Error> {
        Just(self).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
