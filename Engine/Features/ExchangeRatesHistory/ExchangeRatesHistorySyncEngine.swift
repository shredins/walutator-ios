import Foundation
import Combine
import Networking

class ExchangeRatesHistorySyncEngine {
    
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    let userDefaults: UserDefaults
    
    private static let calendar = Calendar.current
    
    init(encoder: JSONEncoder, decoder: JSONDecoder, userDefaults: UserDefaults) {
        self.encoder = encoder
        self.decoder = decoder
        self.userDefaults = userDefaults
    }
    
    func history(for code: String) -> AnyPublisher<[Double], Error> {
        var currencyHistory: ExchangeRatesHistory = .init(code: code)
        var fullHistory: Set<ExchangeRatesHistory> = []
        var count: Int = 30
        
        if let fullHistoryStored = prepareHistoryGenerationInputIfNeeded(code: code,
                                                                         fullHistory: &fullHistory,
                                                                         currencyHistory: &currencyHistory,
                                                                         count: &count) {
            return Result.Publisher(fullHistoryStored).eraseToAnyPublisher()
        }
        
        return Networking
            .exchangeRatesHistory(code: code, count: count)
            .tryMap { [weak userDefaults, weak encoder] (response: LastExchangeRates) in
                let newValues = response.rates.map { $0.bid }
                currencyHistory.add(newRates: newValues)
                
                guard let data = try encoder?.encode(fullHistory) else {
                    throw NSError(domain: "encoding.exchange.rates.history", code: -2, userInfo: nil)
                }
                
                userDefaults?.set(data, forKey: Keys.kExchangeRatesHistory)
                
                return newValues
            }
            .eraseToAnyPublisher()
    }
    
    private func prepareHistoryGenerationInputIfNeeded(code: String, fullHistory: inout Set<ExchangeRatesHistory>, currencyHistory: inout ExchangeRatesHistory, count: inout Int) -> [Double]? {
        if let data = userDefaults.data(forKey: Keys.kExchangeRatesHistory),
           let tempFullHistory = try? decoder.decode(Set<ExchangeRatesHistory>.self, from: data) {
            
            if let tempCurrencyHistory = tempFullHistory.first(where: { $0.code == code }) {
                
                let number = numberOfDaysToFetchExchangeRateFor(tempCurrencyHistory)
                
                switch number {
                case 0:
                    return currencyHistory.exchangeRates
                default:
                    currencyHistory = tempCurrencyHistory
                    fullHistory = tempFullHistory
                    count = number
                }
            } else {
                fullHistory = tempFullHistory
            }
        }
        
        if !fullHistory.contains(currencyHistory) {
            fullHistory.insert(currencyHistory)
        }
        
        return nil
    }
    
    private func numberOfDaysToFetchExchangeRateFor(_ history: ExchangeRatesHistory) -> Int {
        guard let today = Self.calendar.date(bySettingHour: 0, minute: 0, second: 0, of: .now),
              let lastRead = Self.calendar.date(bySettingHour: 0, minute: 0, second: 0, of: history.lastReadDate) else {
                  assertionFailure("Incorrect dates")
                  return 0
              }

        return Self.calendar.dateComponents([.day], from: lastRead, to: today).day ?? 0
    }
}

extension ExchangeRatesHistorySyncEngine: ProfitCalculatorDataSource {
    
    func exchangeRatesHistoryPublisher(for code: String) -> AnyPublisher<[Double], Error> {
        history(for: code)
    }
}
