//
//  AppFeature.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import ComposableArchitecture

@Reducer
struct AppFeature {

    @ObservableState
    struct State: Equatable {
        var myLogs = MyLogsFeature.State()
        var databaseState: DatabaseState = .loading
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case onAppear
        case myLogs(MyLogsFeature.Action)
        case databaseState(DatabaseState)
        case alert(PresentationAction<Alert>)
        case showAlert(error: String)
        enum Alert: Equatable {
            case dismiss
        }
    }
    
    enum DatabaseState: Equatable {
        case loading
        case ready
        case failed(String)
    }
    
    @Dependency(\.persistenceClient) var persistenceClient
    
    var body: some ReducerOf<Self> {
        /*
         Why Scope is used for?
        It keeps the logic for MyLogsFeature isolated, making it reusable and independently testable.
        The parent feature (AppFeature) does not need to know the internal details of MyLogsFeature.
         */
        Scope(state: \.myLogs, action: \.myLogs) {
            MyLogsFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.databaseState = .loading
                return .run { send in
                    do {
                        try await persistenceClient.prepareDatabase()
                        await send(.databaseState(.ready))
                    } catch {
                        await send(.databaseState(.failed(error.localizedDescription)))
                    }
                }
            case .myLogs:
                return .none
            case .databaseState(let newState):
                state.databaseState = newState
                if case .failed(let errorMessage) = newState {
                    Log.error("Database creation error: \(errorMessage)")
                    return .send(.showAlert(error: errorMessage))
                }
                return .none
            case .alert:
                return .none
            case let .showAlert(error):
                state.alert = AlertState {
                    TextState(L10n.error)
                } actions: {
                    ButtonState(action: .dismiss) {
                        TextState(L10n.ok)
                    }
                } message: {
                    TextState(error)
                }
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        /*
        .ifLet elegantly handles optional state, ensuring the app doesn’t crash when alert is nil.
        
        for State-Driven UI: Alerts are controlled entirely by the application state, ensuring consistency with TCA principles.
        
        It monitors the optional alert property in your AppFeature.State. If the alert is not nil, it triggers the appropriate UI (e.g., displaying an alert).
        */
    }
}
