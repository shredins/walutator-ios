import SwiftUI
import ComposableArchitecture

struct ManagePurchasedCurrenciesView: View {
    
    let store: Store<ManagePurchasedCurrenciesState, ManagePurchasedCurrenciesAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Text("Hello")
                Spacer()
            }
            .navigationTitle("manage.purchased.currencies.navigation.title")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ManagePurchasedCurrenciesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ManagePurchasedCurrenciesView(
                store: .init(
                    initialState: .init(),
                    reducer: managePurchasedCurrencies,
                    environment: .init()
                )
            )
        }
    }
}
