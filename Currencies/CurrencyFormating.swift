import Foundation

extension Double {
    
    func currency(_ currencyCode: String? = nil) -> String {
        if var text = NumberFormatter.currency.string(from: .init(value: self)) {
            if let currencyCode = currencyCode {
                text.append(" \(currencyCode)")
            }
            return text
        }
        
        fatalError("Couldn't create formatted text from specified value: \(self)")
    }
}

private extension NumberFormatter {
    
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        return formatter
    }()
}
