import Foundation
import Combine

class PurchasedCurrenciesSyncEngine {
    
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    let userDefaults: UserDefaults

    private static let calendar = Calendar.current
    
    init(encoder: JSONEncoder, decoder: JSONDecoder, userDefaults: UserDefaults) {
        self.encoder = encoder
        self.decoder = decoder
        self.userDefaults = userDefaults
    }

    func myCurrencies() -> AnyPublisher<[PurchasedCurrency], Never> {
        let data = userDefaults.data(forKey: Keys.kMyCurrencies)
        
        return Just(data)
            .replaceNil(with: Data())
            .decode(type: [PurchasedCurrency].self, decoder: decoder)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func bought(code: String, amount: Double, exchangeRate: Double) -> AnyPublisher<Void, Never> {
        myCurrencies()
            .map { stored -> [PurchasedCurrency] in
                let new = PurchasedCurrency(code: code, amount: amount, exchangeRate: exchangeRate)
                return stored + [new]
            }
            .encode(encoder: encoder)
            .assertNoFailure()
            .map { [weak userDefaults] output -> Void in
                userDefaults?.set(output, forKey: Keys.kMyCurrencies)
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    func sold(code: String, amount: Double) -> AnyPublisher<Void, Never> {
        myCurrencies()
            .map { stored in
                stored.sorted(by: { $0.exchangeRate < $1.exchangeRate })
            }
            .map { stored -> [PurchasedCurrency] in
                var soldAmount = amount
                return stored.reduce(into: []) { result, nextElement in
                    guard nextElement.code == code else {
                        result.append(nextElement)
                        return
                    }
                    
                    switch nextElement.amount {
                    case ...soldAmount:
                        soldAmount -= nextElement.amount
                    default:
                        var mutable = nextElement
                        mutable.amount -= soldAmount
                        result.append(mutable)
                    }
                }
            }
            .encode(encoder: encoder)
            .assertNoFailure()
            .map { [weak userDefaults] output -> Void in
                userDefaults?.set(output, forKey: Keys.kMyCurrencies)
                return ()
            }
            .eraseToAnyPublisher()
    }
}
