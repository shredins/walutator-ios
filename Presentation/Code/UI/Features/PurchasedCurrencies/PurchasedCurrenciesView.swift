import SwiftUI
import ComposableArchitecture

struct PurchasedCurrenciesView: View {
    
    let store: Store<PurchasedCurrenciesState, PurchasedCurrenciesAction>
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible())
    ]

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Header("my.purchased.currencies.title")
                    NavigationLink(
                        destination: ManagePurchasedCurrenciesView(
                            store: .init(
                                initialState: .init(),
                                reducer: managePurchasedCurrencies,
                                environment: .init()
                            )
                        ),
                        isActive: viewStore.binding(
                            get: \.isNavigationActive,
                            send: PurchasedCurrenciesAction.managePurchasedNavigation)
                    ) {
                        Text("my.purchased.currencies.manage")
                    }
                }
                .padding([.horizontal, .top], 22)
                Spacing(20)
                if let purchasedCurrencies = viewStore.state.purchasedCurrencies, !purchasedCurrencies.isEmpty {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(0..<purchasedCurrencies.count) { _ in
                            Color.wtOrange
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(15)
                        }
                    }
                    .padding(.horizontal, 20)
                } else {
                    Text("my.purchased.currencies.empty")
                        .padding(.horizontal, 20)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct PurchasedCurrenciesView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasedCurrenciesView(
            store: .init(
                initialState: .init(),
                reducer: purchasedCurrenciesReducer,
                environment: PurchasedCurrenciesEnvironment(
                    uiQueue: .main,
                    purchasedCurrencies: { Effect(value: [.stub, .stub, .stub, .stub]) }
                )
            )
        )
    }
}


