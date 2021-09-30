import Foundation
import Combine
import Networking

protocol ProfitCalculatorDataSource: AnyObject {
    func exchangeRatesHistoryPublisher(for code: String) -> AnyPublisher<[Double], Error>
}

public class ProfitCalculator {
    
    let queue: DispatchQueue
    
    weak var dataSource: ProfitCalculatorDataSource?
    
    init(queue: DispatchQueue = .global()) {
        self.queue = queue
    }
    
    func profit(for purchasedCurrencies: [PurchasedCurrency]) -> AnyPublisher<Double, Never> {
        Publishers.CombineLatest(
            valuation(of: purchasedCurrencies),
            currentValuation(of: purchasedCurrencies)
        )
            .subscribe(on: queue)
            .map { (valuationDuringPurchase: Double, currentValuation: Double) in
                currentValuation - valuationDuringPurchase
            }
            .replaceError(with: 0.0)
            .eraseToAnyPublisher()
    }
    
    private func valuation(of purchasedCurrencies: [PurchasedCurrency]) -> AnyPublisher<Double, Error> {
        let value = purchasedCurrencies.reduce(into: 0) { result, nextElement in
            result += nextElement.amount * nextElement.exchangeRate
        }
        
        return Just(value)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func currentValuation(of purchasedCurrencies: [PurchasedCurrency]) -> AnyPublisher<Double, Error> {
        var allCurrencies = purchasedCurrencies.map { $0.code }
        allCurrencies = Array(Set(allCurrencies))
        
        let publishers = allCurrencies.compactMap { currency in
            dataSource?.exchangeRatesHistoryPublisher(for: currency)
                .combineLatest(
                    Just(currency)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                )
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .map { ratesCollection in
                ratesCollection.reduce(into: 0.0) { result, nextElement in
                    if let rate = nextElement.0.last {
                        let amount = purchasedCurrencies
                            .filter { $0.code == nextElement.1 }
                            .reduce(into: 0.0) { result, purchased in
                                result += purchased.amount
                            }
                        
                        result += amount * rate
                    }
                }
            }
            .eraseToAnyPublisher()
    }
}
