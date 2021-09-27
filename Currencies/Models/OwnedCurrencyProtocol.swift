public protocol OwnedCurrencyProtocol: CurrencyProtocol {
    var amount: Double { get }
    var exchangeRateDiff: Double { get }
}
