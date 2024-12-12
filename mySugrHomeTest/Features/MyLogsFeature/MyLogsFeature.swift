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
        var bgValueText: String = ""
        var saveButtonDisabled: Bool = true
        var isSaving: Bool = false
        @Presents var alert: AlertState<Action.Alert>?
        var myLogs: [DailyLog] = []
    }
    
    enum Action: BindableAction {
        case onAppear
        case selectUnit(UnitType)
        case binding(BindingAction<State>)
        case save
        case alert(PresentationAction<Alert>)
        case showAlert(message: String)
        case performSaving(mgdl: Double, mmol: Double)
        case savingCompleted
        case fetchMyLogs
        case didFetchLogs([DailyLog]?)
        enum Alert: Equatable {
            case dismiss
        }
    }
    
    @Dependency(\.persistenceClient) var persistenceClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchMyLogs)
            case let .selectUnit(unit):
                state.selectedUnit = unit
                return .none
            case .binding(\.bgValueText):
                state.saveButtonDisabled = Double(state.bgValueText) ?? 0.0 > 0.0 ? false : true
                return .none
            case .binding(_):
                return .none
            case .save:
                state.isSaving = true
                return .run { [selectedUnit = state.selectedUnit, value = state.bgValueText] send in
                    guard let numericValue = Double(value) else {
                        return await send(.showAlert(message: L10n.invalidNumericNumber))
                    }
                    switch selectedUnit {
                    case .mmol:
                        // Convert from mmol/L to mg/dL
                        let convertedValue = numericValue * 18.0
                        Log.info("Saving value: \(numericValue) mmol/L -> \(convertedValue) mg/dL")
                        await send(.performSaving(mgdl: convertedValue, mmol: numericValue))
                    case .mgdl:
                        // Convert from mg/dL to mmol/L
                        let convertedValue = numericValue / 18.0
                        Log.info("Saving value: \(numericValue) mg/dL -> \(convertedValue) mmol/L")
                        await send(.performSaving(mgdl: numericValue, mmol: convertedValue))
                    }
                }
            case let .performSaving(mgdl, mmol):
                return .run { send in
                    let dailyLog = DailyLog(mgPerL: mgdl, mmolPerL: mmol)
                    do {
                        try await self.persistenceClient.recordLog(dailyLog)
                        await send(.savingCompleted)
                    } catch {
                        await send(.showAlert(message: error.localizedDescription))
                    }
                }
            case .savingCompleted:
                state.isSaving = false
                state.bgValueText = ""
                return .run { send in
                    await send(.showAlert(message: L10n.changesSavedSuccessfully))
                    await send(.fetchMyLogs)
                }
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
                
            case .fetchMyLogs:
                return .run { send in
                    try await send(.didFetchLogs(self.persistenceClient.fetchDaiLyLog()))
                }
                
            case let .didFetchLogs(logs):
                state.myLogs = logs ?? []
                return .none
            }
            
        }.ifLet(\.$alert, action: \.alert)
        /*
         .ifLet elegantly handles optional state, ensuring the app doesn’t crash when alert is nil.
         
         for State-Driven UI: Alerts are controlled entirely by the application state, ensuring consistency with TCA principles.
         
         It monitors the optional alert property in your AppFeature.State. If the alert is not nil, it triggers the appropriate UI (e.g., displaying an alert).
         */
    }
}
