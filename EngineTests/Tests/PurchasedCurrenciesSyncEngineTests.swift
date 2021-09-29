import XCTest
import Combine

@testable import Engine

class PurchasedCurrenciesSyncEngineTests: XCTestCase {

    var userDefaults: UserDefaults!
    var SUT: PurchasedCurrenciesSyncEngine!
    var decoder: JSONDecoder!
    var encoder: JSONEncoder!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        userDefaults = .mocked(for: #file)
        decoder = .init()
        encoder = .init()
        cancellables = []
        SUT = PurchasedCurrenciesSyncEngine(encoder: encoder, decoder: decoder, userDefaults: userDefaults)
    }
    
    func testGettingEmptyMyCurrencies() {
        SUT
            .myCurrencies()
            .expectSuccess(byStoringIn: &cancellables) { purchased in
                XCTAssertEqual(purchased.count, 0)
            }
            .wait(for: self)
    }

    func testGettingMyCurrencies() {
        let elements = [
            PurchasedCurrency(code: "USD", amount: 10, exchangeRate: 4),
            PurchasedCurrency(code: "USD", amount: 25, exchangeRate: 3.95),
            PurchasedCurrency(code: "EUR", amount: 5, exchangeRate: 4.55)
        ]
        let data = try! encoder.encode(elements)
        
        userDefaults.set(data, forKey: Keys.kMyCurrencies)
        
        // Checking if user defaults properly stored stubs
        XCTAssertNotNil(userDefaults.data(forKey: Keys.kMyCurrencies))
        
        SUT
            .myCurrencies()
            .expectSuccess(byStoringIn: &cancellables) { purchased in
                XCTAssertEqual(purchased.count, 3)
                XCTAssertEqual(purchased.first?.amount, 10)
                XCTAssertEqual(purchased.last?.exchangeRate, 4.55)
            }
            .wait(for: self)
    }
    
    func testBuyingCurrencies() {
        SUT
            .bought(code: "USD", amount: 10, exchangeRate: 3.5)
            .map {
                let data = self.userDefaults.data(forKey: Keys.kMyCurrencies)!
                let object = try! self.decoder.decode([PurchasedCurrency].self, from: data)
                
                // Checking if user defaults contain USD currency
                XCTAssertEqual(object.count, 1)
                XCTAssertEqual(object.first?.code, "USD")
                XCTAssertEqual(object.first?.amount, 10)
            }
            .flatMap { self.SUT.bought(code: "EUR", amount: 25, exchangeRate: 4.5) }
            .eraseToAnyPublisher()
            .expectSuccess(byStoringIn: &cancellables) {
                let data = self.userDefaults.data(forKey: Keys.kMyCurrencies)!
                let object = try! self.decoder.decode([PurchasedCurrency].self, from: data)
                
                // Checking if user defaults contain USD and EUR currency
                XCTAssertEqual(object.count, 2)
                XCTAssertEqual(object.first?.code, "USD")
                XCTAssertEqual(object.first?.amount, 10)
                XCTAssertEqual(object.last?.code, "EUR")
                XCTAssertEqual(object.last?.amount, 25)
            }
            .wait(for: self)
    }
    
    func testSellingEmptyCurrencies() {
        SUT
            .sold(code: "USD", amount: 30)
            .expectSuccess(byStoringIn: &cancellables) {
                let data = self.userDefaults.data(forKey: Keys.kMyCurrencies)!
                let object = try! self.decoder.decode([PurchasedCurrency].self, from: data)

                // Checking if no modifications performed on empty collection
                XCTAssertTrue(object.isEmpty)
            }
            .wait(for: self)
    }
    
    func testSellingCurrencies() {
        let elements = [
            PurchasedCurrency(code: "USD", amount: 10, exchangeRate: 4),
            PurchasedCurrency(code: "USD", amount: 25, exchangeRate: 3.95),
            PurchasedCurrency(code: "EUR", amount: 5, exchangeRate: 4.55)
        ]
        let data = try! encoder.encode(elements)
        
        userDefaults.set(data, forKey: Keys.kMyCurrencies)
        
        // Checking if user defaults properly stored stubs
        XCTAssertNotNil(userDefaults.data(forKey: Keys.kMyCurrencies))

        SUT
            .sold(code: "USD", amount: 30)
            .expectSuccess(byStoringIn: &cancellables) {
                let data = self.userDefaults.data(forKey: Keys.kMyCurrencies)!
                let object = try! self.decoder.decode([PurchasedCurrency].self, from: data)

                // Checking if currencies are correctly sorted and modified
                XCTAssertEqual(object.first?.code, "USD")
                XCTAssertEqual(object.first?.amount, 5)
                XCTAssertEqual(object.first?.exchangeRate, 4)
                XCTAssertEqual(object.last?.code, "EUR")
                XCTAssertEqual(object.last?.amount, 5)
                XCTAssertEqual(object.last?.exchangeRate, 4.55)
            }
            .wait(for: self)
    }
}
