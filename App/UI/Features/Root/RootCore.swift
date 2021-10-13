import Foundation
import Engine
import ComposableArchitecture

struct RootState: Equatable {
    var purchasedCurrenciesState = PurchasedCurrenciesState()
}

enum RootAction: Equatable {
    case purchasedCurrenciesAction(PurchasedCurrenciesAction)
}

struct RootEnvironment {
    
    let uiQueue: AnySchedulerOf<DispatchQueue>
    let engine: Engine
    
    init(mainQueue: AnySchedulerOf<DispatchQueue> = .main,
         engine: Engine = .inject) {
        self.uiQueue = mainQueue
        self.engine = engine
    }
}

let rootReducer = Reducer.combine(
    Reducer<RootState, RootAction, RootEnvironment> { state, action, env in
        switch action {
        case .purchasedCurrenciesAction(.purchasedCurrenciesResponse(let response)):
            return .none
        case .purchasedCurrenciesAction:
            return .none
        }
    },
    purchasedCurrenciesReducer.pullback(
        state: \.purchasedCurrenciesState,
        action: /RootAction.purchasedCurrenciesAction,
        environment: { env in
            PurchasedCurrenciesEnvironment(
                uiQueue: env.uiQueue,
                purchasedCurrencies: {
                    env
                        .engine
                        .purchasedCurrencies
                        .eraseToEffect()
                }
            )
        }
    )
)
