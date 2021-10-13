import SwiftUI

@main
struct WalutatorApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(
                    initialState: RootState(),
                    reducer: rootReducer,
                    environment: RootEnvironment()
                )
            )
        }
    }
}
