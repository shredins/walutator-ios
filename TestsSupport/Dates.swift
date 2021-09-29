import Foundation

extension Date {
    
    private static let parsingStrategy = Date.ParseStrategy(format: "\(day: .twoDigits).\(month: .twoDigits).\(year: .defaultDigits)",
                                                    timeZone: .current)
    
    init(_ text: String) {
        do {
            self = try Date(text, strategy: Self.parsingStrategy)
        } catch {
            fatalError("Incorrect Date creation format \(text)")
        }
    }
}
