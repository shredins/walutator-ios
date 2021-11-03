import Foundation
import Combine

public class Networking {
    
    public typealias NetworkPublisher<Success: Decodable> = AnyPublisher<Success, Error>
    
    public typealias AllCurrencies = NetworkPublisher<[Currencies]>
    public typealias ExchangeRatesHistory = NetworkPublisher<LastExchangeRates>
    
    public static func allCurrencies() -> AllCurrencies {
        if isRunningTests {
            return ApiClientStub(file: "GetAllCurrencies").rawResponseStub()
        } else {
            return GetAllCurrenciesApi().getAllCurrencies()
        }
    }
    
    public static func exchangeRatesHistory(code: String, count: Int) -> ExchangeRatesHistory {
        if isRunningTests {
            return ApiClientStub(file: "GetLastExchangeRates").rawResponseStub()
        } else {
            return GetLastExchangeRatesApi(code: code, count: count).getLastExchangeRates()
        }
    }
}
