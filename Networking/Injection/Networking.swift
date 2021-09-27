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
    
    static func last30ExchangeRates(code: String) -> Last30ExchangeRates {
        #if TESTING
        ApiClientStub(file: "GetLast30ExchangeRates").rawResponseStub()
        #else
        GetLast30ExchangeRatesApi(code: code).getLast30ExchangeRates()
        #endif
    }
}
