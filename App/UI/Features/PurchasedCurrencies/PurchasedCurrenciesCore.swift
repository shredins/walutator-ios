import Foundation
import Engine
import ComposableArchitecture

struct PurchasedCurrenciesState: Equatable {
    var purchasedCurrencies: [PurchasedCurrency]?
    var isNavigationActive: Bool = false
}

enum PurchasedCurrenciesAction: Equatable {
    case onAppear
    case managePurchasedNavigation(active: Bool)
    case purchasedCurrenciesResponse([PurchasedCurrency])
}

struct PurchasedCurrenciesEnvironment {
    var uiQueue: AnySchedulerOf<DispatchQueue>
    var purchasedCurrencies: () -> Effect<[PurchasedCurrency], Never>
}

let purchasedCurrenciesReducer = Reducer<PurchasedCurrenciesState, PurchasedCurrenciesAction, PurchasedCurrenciesEnvironment> { state, action, env in
    switch action {
    case .onAppear:
        return env.purchasedCurrencies()
            .map(PurchasedCurrenciesAction.purchasedCurrenciesResponse)
            .receive(on: env.uiQueue)
            .eraseToEffect()
    case .managePurchasedNavigation(let active):
        state.isNavigationActive = active
        return .none
    case .purchasedCurrenciesResponse(let response):
        state.purchasedCurrencies = response
        return .none
    }
}
