import Foundation
import Combine

public class Networking {
    
    public typealias NetworkPublisher<Success: Decodable> = AnyPublisher<Success, Error>
    
    public typealias AllCurrencies = NetworkPublisher<[Currencies]>
    public typealias ExchangeRatesHistory = NetworkPublisher<LastExchangeRates>
    
    public static func allCurrencies() -> AllCurrencies {
        #if TESTING
        ApiClientStub(file: "GetAllCurrencies").rawResponseStub()
        #else
        GetAllCurrenciesApi().getAllCurrencies()
        #endif
    }
    
    public static func exchangeRatesHistory(code: String, count: Int) -> ExchangeRatesHistory {
        #if TESTING
        ApiClientStub(file: "GetLastExchangeRates").rawResponseStub()
        #else
        GetLastExchangeRatesApi(code: code, count: count).getLastExchangeRates()
        #endif
    }
}
