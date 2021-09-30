import Foundation
import Combine
import Networking

public protocol Engine {
    
    var purchasedCurrencies: AnyPublisher<[PurchasedCurrency], Never> { get }
    var allCurrencies: Networking.AllCurrencies { get }
    var profit: AnyPublisher<Double, Never> { get }
    
    func bought(my code: String, amount: Double, exchangeRate: Double) -> AnyPublisher<Void, Never>
    func sold(my code: String, amount: Double) -> AnyPublisher<Void, Never>
    
    /// Fetches exchange rates for specified currency
    subscript(code: String) -> AnyPublisher<[Double], Error> { get }
}

public extension Engine where Self == EngineFacade {
    
    static var inject: EngineFacade {
        EngineFacade()
    }
}
