import Foundation
import Combine

public struct Currencies: Decodable {
    let rates: [Currency]
}

public struct Currency: Decodable {
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
