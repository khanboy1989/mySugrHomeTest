//
//  MyLogsFeature.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import ComposableArchitecture

@Reducer
struct MyLogsFeature {
    
    @ObservableState
    struct State: Equatable {
        var availableUnits: [UnitType] = UnitType.allCases
        var selectedUnit: UnitType = .mmol
        var bgValueText: String = "0"
    }
    
    enum Action: BindableAction {
        case onAppear
        case selectUnit(UnitType)
        case binding(BindingAction<State>)
        case save
    }
    
    @Dependency(\.persistenceClient) var persistenceClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case let .selectUnit(unit):
                state.selectedUnit = unit
                return .none
            case .binding(\.bgValueText):
                print("bgValueText: \(state.bgValueText)")
                return .none
            case .binding(_):
                return .none
            case .save:
                return .none
            }
        }
    }
}
