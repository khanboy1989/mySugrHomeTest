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
    }
    
    enum Action {
        case onAppear
        case selectUnit(UnitType)
    }
    
    @Dependency(\.persistenceClient) var persistenceClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case let .selectUnit(unit):
                state.selectedUnit = unit
                return .none
            }
        }
    }
}
