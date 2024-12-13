//
//  AppView.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import SwiftUI
import ComposableArchitecture

/*
 It is not necessary to create the AppFeature and AppView but
 It has been created to have it ready for future, ie. if we
 want to have a LoginFeature or SplashFeature we can inject it here easily
 */
struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    var body: some View {
        Group {
            if store.databaseState == .loading {
                ProgressView(L10n.pleaseWait)
                    
            } else if store.databaseState == .ready {
                MyLogsView(
                    store: store.scope(
                        state: \.myLogs,
                        action: \.myLogs
                    )
                )
            }
        }.onAppear {
            store.send(.onAppear)
        }
        .alert($store.scope(state: \.alert, action: \.alert)) //Alert modifier to display alerts dynamically when state is updated
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
