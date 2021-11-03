import Foundation

struct CurrencyPreviewViewModel {
    
    let values: [Double]
    let min: Double
    let max: Double
    let minMaxGranularDiff: Double
    
    let xGranularity: Int = 0
    let yGranularity: Int = 0

    init(values: [Double]) {
        self.values = values
        self.min = values.min() ?? 0
        self.max = values.max() ?? 0
        self.minMaxGranularDiff = (max - min) / Double(yGranularity + 1)
    }
    
    func text(for index: Int) -> String {
        let amount = max - Double(index) * minMaxGranularDiff
        
        if var value = NumberFormatter.formatter.string(from: .init(value: amount)) {
            value.append(" zł")
            
            if index == 0 {
                value.append(" (MAX)")
            }
            
            return value
        }

        
        return ""
    }
    
    func minText() -> String {
        if let value = NumberFormatter.formatter.string(from: .init(value: min)) {
            return value + " zł (MIN)"
        }
        
        return ""
    }
}

private extension NumberFormatter {
    
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 3
        formatter.decimalSeparator = ","
        return formatter
    }()
}
