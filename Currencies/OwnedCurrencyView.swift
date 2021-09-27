import SwiftUI

struct OwnedCurrencyView: View {
    
    let amount: Double
    let currencyName: String
    let isIncome: Bool
    let valueDiff: Double
    
    init(amount: Double, currencyName: String, diff: Double) {
        self.amount = amount
        self.currencyName = currencyName
        self.isIncome = diff > 0
        self.valueDiff = diff
    }

    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack(spacing: 2) {
                    Image(systemName: isIncome ? "arrow.up.square.fill" : "arrow.down.square.fill")
                        .font(.system(size: 15))
                        .foregroundColor(isIncome ? .green : .red)
                    Text(amount.currency())
                        .font(.headline)
                }
                Text(currencyName)
                    .font(.subheadline)
            }
            Spacer()
            Text(valueDiff.currency("zł"))
                .font(.body)
                .foregroundColor(isIncome ? .green : .red)
        }
    }
}

struct OwnedCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        OwnedCurrencyView(amount: 500, currencyName: "dolar amerykański", diff: -99.90)
            .frame(width: 200)
    }
}
