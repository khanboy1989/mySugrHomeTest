//
//  mySugrHomeTestApp.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct mySugrHomeTestApp: App {
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
            ._printChanges()
    }
    var body: some Scene {
        WindowGroup {
            AppView(store: mySugrHomeTestApp.store) // Instantiate the AppView from the store of AppFeature
        }
    }
}
