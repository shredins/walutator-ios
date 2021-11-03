import XCTest
import Engine
import Networking
import Combine

@testable import Engine

class AllCurrenciesSyncEngineTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }

    func testSyncingAllCurrencies() {
        let defaults: UserDefaults = .mocked(for: #file)
        let SUT = AllCurrenciesSyncEngine(encoder: .init(), decoder: .init(), userDefaults: defaults)
        
        XCTAssertNil(defaults.object(forKey: Keys.kAllCurrencies))
        
        SUT
            .allCurrencies()
            .expectSuccess(byStoringIn: &cancellables) { (currencies: [Currencies]) in
                XCTAssertEqual(currencies.count, 1)
                XCTAssertEqual(currencies.first?.rates.first?.code, "code")
                XCTAssertEqual(currencies.first?.rates.first?.currency, "currency")
                XCTAssertNotNil(defaults.object(forKey: Keys.kAllCurrencies))
            }
            .wait(for: self)
    }
}
