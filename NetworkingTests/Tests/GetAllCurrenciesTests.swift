import XCTest
import Combine

@testable import Networking

class GetAllCurrenciesTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }

    func testSuccess() {
        GetAllCurrenciesApi(apiClient: .success(stub: "GetAllCurrencies"))
            .getAllCurrencies()
            .expectSuccess(byStoringIn: &cancellables) {
                XCTAssertEqual($0.first?.rates.count, 1)
                XCTAssertEqual($0.first?.rates.first?.code, "code")
                XCTAssertEqual($0.first?.rates.first?.currency, "currency")
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
            .allCurrencies()
            .expectSuccess(byStoringIn: &cancellables) {
                XCTAssertEqual($0.first?.rates.count, 1)
                XCTAssertEqual($0.first?.rates.first?.code, "code")
                XCTAssertEqual($0.first?.rates.first?.currency, "currency")
            }
            .wait(for: self)
    }
}
