import Foundation
import Combine

public struct LastExchangeRates: Decodable {
    let rates: [ExchangeRate]
}

public struct ExchangeRate: Decodable {
    public let bid: Double
}

class GetLast30ExchangeRatesApi {
    
    let apiClient: ApiClientProtocol
    let url: URLRequest
    
    init(code: String, apiClient: ApiClientProtocol = ApiClient()) {
        self.apiClient = apiClient
        self.url = URLRequest(stringLiteral: "http://api.nbp.pl/api/exchangerates/rates/c/\(code.lowercased())/last/30/?format=json")
    }
    
    func getLast30ExchangeRates() -> AnyPublisher<LastExchangeRates, Error> {
        apiClient.execute(request: url)
    }
}
