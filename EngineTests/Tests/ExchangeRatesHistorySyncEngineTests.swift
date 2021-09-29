import XCTest
import Combine

@testable import Engine

class ExchangeRatesHistorySyncEngineTests: XCTestCase {
    
    var userDefaults: UserDefaults!
    var SUT: ExchangeRatesHistorySyncEngine!
    var decoder: JSONDecoder!
    var encoder: JSONEncoder!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        userDefaults = .mocked(for: #file)
        decoder = .init()
        encoder = .init()
        cancellables = []
        SUT = ExchangeRatesHistorySyncEngine(encoder: encoder, decoder: decoder, userDefaults: userDefaults)
    }

    func testSyncingExchangeRatesHistory() {
        // Checking if nothing stored in user defaults
        XCTAssertNil(userDefaults.data(forKey: Keys.kExchangeRatesHistory))
        
        SUT
            .history(for: "USD")
            .map { rates in
                // Checking after USD sync
                XCTAssertEqual(rates.first, 1)
                XCTAssertEqual(rates.last, -2)
                XCTAssertNotNil(self.userDefaults.data(forKey: Keys.kExchangeRatesHistory))
            }
            .flatMap { self.SUT.history(for: "EUR") }
            .eraseToAnyPublisher()
            .expectSuccess(byStoringIn: &cancellables) { (rates: [Double]) in
                // Checking after EUR sync
                XCTAssertEqual(rates.first, 1)
                XCTAssertEqual(rates.last, -2)
                XCTAssertNotNil(self.userDefaults.data(forKey: Keys.kExchangeRatesHistory))
                
                let data = self.userDefaults.data(forKey: Keys.kExchangeRatesHistory)!
                let object = try! self.decoder.decode(Set<ExchangeRatesHistory>.self, from: data)
                
                // Checking if both USD and EUR are stored
                XCTAssertEqual(object.count, 2)
                XCTAssertNotNil(object.first(where: { $0.code == "USD" }))
                XCTAssertNotNil(object.first(where: { $0.code == "EUR" }))
            }
            .wait(for: self)
    }
    
    func testUpdatingCurrencyHistory() {
        // Checking if nothing stored in user defaults
        XCTAssertNil(userDefaults.data(forKey: Keys.kExchangeRatesHistory))
        
        let date = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        let history = ExchangeRatesHistory(code: "USD", lastReadDate: date, exchangeRates: [1, 2, 3])
        let data = try! encoder.encode(Set([history]))
        
        userDefaults.set(data, forKey: Keys.kExchangeRatesHistory)
        
        SUT
            .history(for: "USD")
            .expectSuccess(byStoringIn: &cancellables) { rates in
                XCTAssertEqual(rates.first, 1)
                XCTAssertEqual(rates.last, -2)
                
                let data = self.userDefaults.data(forKey: Keys.kExchangeRatesHistory)!
                let object = try! self.decoder.decode(Set<ExchangeRatesHistory>.self, from: data)
                
                // Checking if USD has updated rates
                XCTAssertEqual(object.first!.exchangeRates.count, 5)
                XCTAssertEqual(object.first!.exchangeRates.first, 1)
                XCTAssertEqual(object.first!.exchangeRates.last, -2)

            }
            .wait(for: self)
    }
}
