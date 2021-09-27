//
//  SwiftUIView.swift
//  
//
//  Created by Tomasz Korab on 04/09/2021.
//

import SwiftUI

public struct CurrenciesView: View {
    
    @Binding var selection: String?
    @Binding var currencies: [CurrencyProtocol]
    @Binding var ownedCurrencies: [OwnedCurrencyProtocol]
    
    public init(currencies: Binding<[CurrencyProtocol]>, ownedCurrencies: Binding<[OwnedCurrencyProtocol]>, selection: Binding<String?>) {
        self._currencies = currencies
        self._ownedCurrencies = ownedCurrencies
        self._selection = selection
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    Text("Moje")
                        .font(.largeTitle)
                    ForEach(ownedCurrencies, id: \.code) { ownedCurrency in
                        SelectionView(isSelected: $selection, id: ownedCurrency.code) {
                            OwnedCurrencyView(amount: ownedCurrency.amount,
                                              currencyName: ownedCurrency.currency,
                                              diff: ownedCurrency.exchangeRateDiff)
                        }
                    }
                    Text("Inne")
                        .font(.largeTitle)
                    ForEach(currencies, id: \.code) { currency in
                        SelectionView(isSelected: $selection, id: currency.code) {
                            SingleCurrencyView(fullName: currency.currency, code: currency.code)
                                .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false)
                        }
                    }
                }.padding()
            }
            .listStyle(SidebarListStyle())
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
        
    private struct Currency: CurrencyProtocol {
        let currency: String
        let code: String
    }
    
    private struct OwnedCurrency: OwnedCurrencyProtocol {
        let currency: String
        let code: String
        let amount: Double
        let exchangeRateDiff: Double
    }

    static var previews: some View {
        let currenciesBinding = Binding<[CurrencyProtocol]>.init(get: {
            [
                Currency(currency: "Dolar amerykański", code: "USD"),
                Currency(currency: "Funt brytyjski", code: "GBP"),
                Currency(currency: "Euro", code: "EUR")
            ]
        }, set: { _ in })
        
        let ownedBinding = Binding<[OwnedCurrencyProtocol]>.init(get: {
            [
                OwnedCurrency(currency: "Dolar amerykański", code: "USD", amount: 500, exchangeRateDiff: 0.15)
            ]
        }, set: { _ in })
        
        return CurrenciesView(currencies: currenciesBinding, ownedCurrencies: ownedBinding, selection: .constant(nil))
    }
}
