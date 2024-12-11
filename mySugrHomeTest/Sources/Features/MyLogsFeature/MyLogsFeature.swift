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
        
    }
    
    enum Action {
        case onAppear 
    }
    
    @Dependency(\.persistenceClient) var persistenceClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
