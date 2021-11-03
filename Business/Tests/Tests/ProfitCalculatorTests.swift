import XCTest
import Combine

@testable import Engine

class ProfitCalculatorTests: XCTestCase {

    var SUT: ProfitCalculator!
    var queue: DispatchQueue!
    var dataSource: ProfitCalculatorDataSource!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        queue = DispatchQueue(label: #file)
        dataSource = ProfitCalculatorDataSourceStub()
        cancellables = []
        SUT = ProfitCalculator(queue: queue)
        SUT.dataSource = dataSource
    }
    
    func testProfitCalculation() {
        var output: Double?
        let purchased = [
            PurchasedCurrency(code: "USD", amount: 10, exchangeRate: 5)
        ]
        
        XCTAssertTrue(Thread.isMainThread)
        
        SUT
            .profit(for: purchased)
            .expectSuccess(byStoringIn: &cancellables) { profit in
                output = profit
                XCTAssertFalse(Thread.isMainThread)
            }
            .wait(for: self)
        
        queue.sync {}
        
        XCTAssertEqual(output, -10)
    }
    
    func testProfitCalculationForNoPurchased() {
        SUT
            .profit(for: [])
            .expectSuccess(byStoringIn: &cancellables) { profit in
                XCTAssertEqual(profit, 0)
            }
            .wait(for: self)
    }
    
    func testProfitCalculationForNoDataSource() {
        SUT.dataSource = nil
        
        SUT
            .profit(for: [])
            .expectSuccess(byStoringIn: &cancellables) { profit in
                XCTAssertEqual(profit, 0)
            }
            .wait(for: self)
    }
}

private extension ProfitCalculatorTests {
    
    class ProfitCalculatorDataSourceStub: ProfitCalculatorDataSource {
        
        func exchangeRatesHistoryPublisher(for code: String) -> AnyPublisher<[Double], Error> {
            Just([1, 2, 3, 4])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
