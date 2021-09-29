import Foundation
import Networking

class AllCurrenciesSyncEngine {
    
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    let userDefaults: UserDefaults
    
    init(encoder: JSONEncoder, decoder: JSONDecoder, userDefaults: UserDefaults) {
        self.encoder = encoder
        self.decoder = decoder
        self.userDefaults = userDefaults
    }
    
    func allCurrencies() -> Networking.AllCurrencies {
        if let data = userDefaults.data(forKey: Keys.kAllCurrencies),
           let stored = try? decoder.decode([Currencies].self, from: data) {
            return Result.Publisher(stored).eraseToAnyPublisher()
        }
        
        return Networking
            .allCurrencies()
            .tryMap { [weak userDefaults, weak encoder] (response: [Currencies]) in
                guard let data = try encoder?.encode(response) else {
                    throw NSError(domain: "encoding.all.currencies", code: -1, userInfo: nil)
                }
                
                userDefaults?.set(data, forKey: Keys.kAllCurrencies)
                return response
            }
            .eraseToAnyPublisher()
    }
}
