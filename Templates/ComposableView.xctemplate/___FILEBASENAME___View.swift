import SwiftUI
import ComposableArchitecture

struct ___VARIABLE_productName___View: View {
    
    let store: Store<___VARIABLE_productName___State, ___VARIABLE_productName___Action>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Text("___VARIABLE_productName___")
        }
    }
}

struct ___VARIABLE_productName___View_Previews: PreviewProvider {
    static var previews: some View {
        ___VARIABLE_productName___View(
            store: .init(
                initialState: .init(),
                reducer: ___VARIABLE_reducerName___,
                environment: .init()
            )
        )
    }
}
