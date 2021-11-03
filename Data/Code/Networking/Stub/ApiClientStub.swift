import Foundation
import Combine

final class ApiClientStub: ApiClientProtocol {
    
    private static let decoder = JSONDecoder()
    
    let data: Data?
    let error: Error?
    
    init(file resourceName: String) {
        guard let url = Bundle(for: Self.self).url(forResource: resourceName, withExtension: "json") else {
            fatalError("Couldn't load resource: \(resourceName)")
        }
        
        do {
            self.data = try Data(contentsOf: url)
            self.error = nil
        } catch {
            fatalError("Couldn't load contents for: \(url.absoluteString)")
        }
    }
    
    init(error: Error) {
        self.error = error
        self.data = nil
    }
    
    func rawResponseStub<Response: Decodable>() -> AnyPublisher<Response, Error> {
        dataTaskPublisher(from: "mock://")
            .map { $0.data }
            .decode(type: Response.self, decoder: Self.decoder)
            .eraseToAnyPublisher()
    }
    
    func dataTaskPublisher(from request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> {
        guard isRunningTests else {
            fatalError("Invalid coniguration or using it in non-testing mode")
        }
        
        if let data = data {
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return Just((data: data, response: response))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if let error = error {
            return Result.Publisher(error)
                .eraseToAnyPublisher()
        } else {
            fatalError("Invalid coniguration or using it in non-testing mode")
        }
    }
}
