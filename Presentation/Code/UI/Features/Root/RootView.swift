import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    let store: Store<RootState, RootAction>
    
    let currencies: [String] = [
        "GBP", "USD", "EUR", "CAD", "AUD", "JPY", "CZK", "DKK", "NOK", "SEK", "XDR"
    ]
    
    let exchangeRates: [(String, Double)] = [
        ("28.09.2021", 3.95),
        ("27.09.2021", 3.92),
        ("26.09.2021", 3.97),
        ("25.09.2021", 3.91),
        ("24.09.2021", 3.93)
    ]
    
    let currenciesColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible())
    ]
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        PurchasedCurrenciesView(
                            store: store.scope(
                                state: \.purchasedCurrenciesState,
                                action: RootAction.purchasedCurrenciesAction
                            )
                        )
                        Spacing(20)
                        ZStack(alignment: .leading) {
                            Color
                                .gray
                                .opacity(0.1)
                            VStack(alignment: .leading, spacing: 0) {
                                Header("Zestawienie")
                                Spacing(15)
                                VStack(alignment: .leading, spacing: 3) {
                                    HStack {
                                        Text("4 500,99 zł")
                                            .font(.largeTitle)
                                        Image(systemName: "info.circle")
                                            .font(.system(size: 25, weight: .light))
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    Text("+19,99 zł (2,05%)")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                    Spacing(20)
                                    HStack {
                                        Header("Dolar amerykański")
                                        Button("Historia") {
                                            
                                        }
                                    }
                                }
                            }
                            .padding(22)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        ZStack {
                            LinearGradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0)],
                                           startPoint: .top,
                                           endPoint: .bottom)
                            CurrencyPreview(values: [1, 2, 4, 1, 6, 7, 1, 2, 5, 10, 5])
                                .frame(height: 150)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        Spacing(60)
                        LazyVGrid(columns: currenciesColumns, spacing: 10) {
                            ForEach(0..<currencies.count) { index in
                                ZStack {
                                    Color
                                        .accentColor
                                        .opacity(0.7)
                                        .cornerRadius(12)
                                    Text(currencies[index])
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(10)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .navigationBarTitle("WALUTATOR", displayMode: .large)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: .init(
                initialState: .init(),
                reducer: rootReducer,
                environment: RootEnvironment(
                    mainQueue: .main,
                    engine: .inject
                )
            )
        )
    }
}
