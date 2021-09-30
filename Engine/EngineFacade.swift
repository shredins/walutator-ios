import Foundation
import Networking
import Combine

public final class EngineFacade {
    
    let userDefaults: UserDefaults
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    let queue: DispatchQueue
    
    lazy var purchasedCurrenciesSyncEngine = PurchasedCurrenciesSyncEngine(
        encoder: encoder,
        decoder: decoder,
        userDefaults: userDefaults
    )
    
    lazy var allCurrenciesSyncEngine = AllCurrenciesSyncEngine(
        encoder: encoder,
        decoder: decoder,
        userDefaults: userDefaults
    )
    
    lazy var exchangeRatesHistorySyncEngine = ExchangeRatesHistorySyncEngine(
        encoder: encoder,
        decoder: decoder,
        userDefaults: userDefaults
    )
    
    lazy var profitCalculator: ProfitCalculator = {
        let calculator = ProfitCalculator(queue: queue)
        calculator.dataSource = exchangeRatesHistorySyncEngine
        return calculator
    }()
    
    init(
        userDefaults: UserDefaults = .standard,
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init(),
        queue: DispatchQueue = .global()
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
        self.queue = queue
    }
}

extension EngineFacade: Engine {
    
    public var purchasedCurrencies: AnyPublisher<[PurchasedCurrency], Never> {
        purchasedCurrenciesSyncEngine.myCurrencies()
    }
    
    public var allCurrencies: Networking.AllCurrencies {
        allCurrenciesSyncEngine.allCurrencies()
    }
    
    public var profit: AnyPublisher<Double, Never> {
        purchasedCurrencies
            .flatMap { purchased in
                self.profitCalculator.profit(for: purchased)
            }
            .eraseToAnyPublisher()
    }
    
    public func bought(my code: String, amount: Double, exchangeRate: Double) -> AnyPublisher<Void, Never> {
        purchasedCurrenciesSyncEngine.bought(code: code, amount: amount, exchangeRate: exchangeRate)
    }
    
    public func sold(my code: String, amount: Double) -> AnyPublisher<Void, Never> {
        purchasedCurrenciesSyncEngine.sold(code: code, amount: amount)
    }
    
    public subscript(code: String) -> AnyPublisher<[Double], Error> {
        exchangeRatesHistorySyncEngine.history(for: code)
    }
}
