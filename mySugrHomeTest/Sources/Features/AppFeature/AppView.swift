//
//  AppView.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    var body: some View {
        Group {
            if store.databaseState == .loading {
                ProgressView("Preparing database...")
                    .onAppear {
                        store.send(.onAppear)
                    }
            } else if store.databaseState == .ready {
                MyLogsView(
                    store: store.scope(
                        state: \.myLogs,
                        action: \.myLogs
                    )
                )
            }
        }
        .alert($store.scope(state: \.alert, action: \.alert)) //Alert modifier to display alerts dynamically when state is updated
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
