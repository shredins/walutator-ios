import Foundation
import Combine

public struct LastExchangeRates: Decodable {
    public let rates: [ExchangeRate]
}

public struct ExchangeRate: Decodable {
    public let bid: Double
}

class GetLastExchangeRatesApi {
    
    let apiClient: ApiClientProtocol
    let url: URLRequest
    
    init(code: String, count: Int, apiClient: ApiClientProtocol = ApiClient()) {
        self.apiClient = apiClient
        self.url = URLRequest(stringLiteral: "http://api.nbp.pl/api/exchangerates/rates/c/\(code.lowercased())/last/\(count)/?format=json")
    }
    
    func getLastExchangeRates() -> AnyPublisher<LastExchangeRates, Error> {
        apiClient.execute(request: url)
    }
}
