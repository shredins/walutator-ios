import Foundation
import Networking
import Combine

public final class EngineFacade {
    
    let userDefaults: UserDefaults
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
}

extension EngineFacade: Engine {
    
    public var myCurrencies: AnyPublisher<[String], Error> {
        Result.Publisher([]).eraseToAnyPublisher()
    }
    
    public var allCurrencies: Networking.AllCurrencies {
        fatalError()
    }
    
    public var profit: Double {
        0
    }
    
    public func add(my currency: String, value: Double, rate: Double) {
        
    }
    
    public func delete(my currency: String) {
        
    }
    
    public subscript(code: String) -> AnyPublisher<[Double], Error> {
        Result.Publisher([]).eraseToAnyPublisher()
    }
}
