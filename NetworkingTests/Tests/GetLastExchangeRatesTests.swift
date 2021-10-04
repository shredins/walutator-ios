import XCTest
import Combine

@testable import Networking

class GetLast30ExchangeRatesTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }

    func testSuccess() {
        GetLastExchangeRatesApi(code: "", count: 30, apiClient: .success(stub: "GetLastExchangeRates"))
            .getLastExchangeRates()
            .expectSuccess(byStoringIn: &cancellables) {
                XCTAssertEqual($0.rates.count, 2)
                XCTAssertEqual($0.rates.first?.bid, 1.0)
                XCTAssertEqual($0.rates.last?.bid, -2.0)
            }
            .wait(for: self)
    }
    
    func testFailure() {
        GetAllCurrenciesApi(apiClient: .failure(URLError(.timedOut)))
            .getAllCurrencies()
            .expectFailure(byStoringIn: &cancellables) {
                XCTAssertTrue($0 is URLError)
            }
            .wait(for: self)
    }
    
    func testStubTriggering() {
        Networking
            .exchangeRatesHistory(code: "", count: 0)
            .expectSuccess(byStoringIn: &cancellables) {
                XCTAssertEqual($0.rates.count, 2)
                XCTAssertEqual($0.rates.first?.bid, 1.0)
                XCTAssertEqual($0.rates.last?.bid, -2.0)
            }
            .wait(for: self)
    }
}
