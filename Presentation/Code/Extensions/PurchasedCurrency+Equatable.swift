import Foundation

extension PurchasedCurrency: Equatable {

    public static func == (lhs: PurchasedCurrency, rhs: PurchasedCurrency) -> Bool {
        lhs.amount == rhs.amount &&
        lhs.code == rhs.code &&
        lhs.exchangeRate == rhs.exchangeRate
    }
}
