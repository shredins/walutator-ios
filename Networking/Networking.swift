import Foundation
import Combine

public class Networking {
    
    public typealias NetworkPublisher<Success: Decodable> = AnyPublisher<Success, Error>
    
    public typealias AllCurrencies = NetworkPublisher<[Currencies]>
    public typealias Last30ExchangeRates = NetworkPublisher<LastExchangeRates>
    
    static func allCurrencies() -> AllCurrencies {
        #if TESTING
        ApiClientStub(file: "GetAllCurrencies").rawResponseStub()
        #else
        GetAllCurrenciesApi().getAllCurrencies()
        #endif
    }
    
    static func lastExchangeRates(code: String, count: Int) -> Last30ExchangeRates {
        #if TESTING
        ApiClientStub(file: "GetLastExchangeRates").rawResponseStub()
        #else
        GetLastExchangeRatesApi(code: code, count: count).getLastExchangeRates()
        #endif
    }
}
