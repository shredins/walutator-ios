import Foundation
import Combine

protocol ApiClientProtocol {
    func execute<Success: Decodable>(request: URLRequest) -> AnyPublisher<Success, Error>
    func dataTaskPublisher(from request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error>
}


extension ApiClientProtocol {
    
    func execute<Success: Decodable>(request: URLRequest) -> AnyPublisher<Success, Error> {
        return dataTaskPublisher(from: request)
            .catch { error in
                Fail(error: error)
            }
            .map { (data: Data, response: URLResponse) in
                data
            }
            .decode(type: Success.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

final class ApiClient: ApiClientProtocol {
    
    let session: URLSession = .shared
    
    func dataTaskPublisher(from request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> {
        session.dataTaskPublisher(for: request)
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
