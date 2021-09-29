import Foundation

class ExchangeRatesHistory: Codable, Identifiable, Hashable {
    
    let code: String
    var lastReadDate: Date
    var exchangeRates: [Double]
    
    var id: String {
        code
    }
    
    init(code: String, lastReadDate: Date = .init(), exchangeRates: [Double] = []) {
        self.code = code
        self.lastReadDate = lastReadDate
        self.exchangeRates = exchangeRates
    }
    
    func add(newRates: [Double]) {
        lastReadDate = .now
        exchangeRates.append(contentsOf: newRates)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
    
    static func == (lhs: ExchangeRatesHistory, rhs: ExchangeRatesHistory) -> Bool {
        lhs.id == rhs.id
    }
}
