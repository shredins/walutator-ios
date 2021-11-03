import Foundation
import Combine

public struct Currencies: Codable {
    public let rates: [Currency]
}

public struct Currency: Codable {
    public let currency, code: String
}

class GetAllCurrenciesApi {
    
    let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol = ApiClient()) {
        self.apiClient = apiClient
    }
    
    func getAllCurrencies() -> AnyPublisher<[Currencies], Error> {
        apiClient.execute(request: "http://api.nbp.pl/api/exchangerates/tables/C?format=json")
    }
}
