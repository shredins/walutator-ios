import Foundation
import Combine
import Networking

public protocol Engine {
    
    var myCurrencies: AnyPublisher<[String], Error> { get }
    var allCurrencies: Networking.AllCurrencies { get }
    var profit: Double { get }
    
    func add(my currency: String, value: Double, rate: Double)
    func delete(my currency: String)
    
    /// Fetches exchange rates for specified currency
    subscript(code: String) -> AnyPublisher<[Double], Error> { get }
}
