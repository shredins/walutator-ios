public struct PurchasedCurrency: Codable {
    public let code: String
    public var amount: Double
    public let exchangeRate: Double
}

#if DEBUG
extension PurchasedCurrency {
    public static let stub = Self(
        code: "CDE",
        amount: 10.0,
        exchangeRate: 4.50
    )
}
#endif
