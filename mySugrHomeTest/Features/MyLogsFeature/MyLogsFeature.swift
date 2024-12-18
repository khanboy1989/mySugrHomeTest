//
//  MyLogsFeature.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct MyLogsFeature {
    @ObservableState
    struct State: Equatable {
        var availableUnits: [UnitType] = UnitType.allCases
        var selectedUnit: UnitType = .mmol
        var bgValueText: String = ""
        var saveButtonDisabled: Bool = true
        var isSaving: Bool = false
        var myLogs: [DailyLog] = []
        var averageBgValue: String = ""
        @Presents var alert: AlertState<Action.Alert>?
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
        case didFetchLogs([DailyLog])
        case calculateAverage([DailyLog])
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
                return .send(.calculateAverage(state.myLogs))
            case .binding(\.bgValueText):
                state.saveButtonDisabled = !(Double(state.bgValueText) ?? 0.0 > 0.0)
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
//                    await send(.fetchMyLogs)
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
                
            case .fetchMyLogs: // Fetches the logs from persistenceClient (CoreData)
                return .run { send in
                    for try await logs in self.persistenceClient.streamDailyLogs(nil, [NSSortDescriptor(key: "createdAt", ascending: true)]) {
                        await send(.didFetchLogs(logs))
                    }
//                    try await send(.didFetchLogs(self.persistenceClient.fetchDaiLyLog()))
                }
            case let .didFetchLogs(logs): // Triggers when logs are fetched
                state.myLogs = logs.sorted { $0.dateAdded > $1.dateAdded } //sort from newest to latest
                return .send(.calculateAverage(logs))
            case let .calculateAverage(logs):
                guard !logs.isEmpty else {
                    state.averageBgValue = "0 \(state.selectedUnit == .mmol ? L10n.mmoll : L10n.mgdl)"
                    return .none
                } // If it is empty do not calculate
                
                let average: Double
                switch state.selectedUnit {
                case .mgdl:
                    // Reduce operation used to calculate the sum of mgPerl values entered by the user
                    average = logs.map(\.mgPerL).reduce(0, +) / Double(logs.count)
                    state.averageBgValue = "\(average.formatToString(with: 1)) \(L10n.mgdl)"
                    
                case .mmol:
                    // Reduce operation used to calculate the sum of mmol values entered by the user
                    average = logs.map(\.mmolPerL).reduce(0, +) / Double(logs.count)
                    state.averageBgValue = "\(average.formatToString(with: 1)) \(L10n.mmoll)"
                }
                return .none
            }
        }.ifLet(\.$alert, action: \.alert)
        /*
         .ifLet elegantly handles optional state, ensuring the app doesn’t crash when alert is nil.
         
         for State-Driven UI: Alerts are controlled entirely by the application state, ensuring consistency with TCA principles.
         
         It monitors the optional alert property in your MyLogsFeature.State. If the alert is not nil, it triggers the appropriate UI (e.g., displaying an alert).
         */
    }
}
