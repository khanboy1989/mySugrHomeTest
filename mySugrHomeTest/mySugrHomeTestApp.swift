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
    let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    var body: some Scene {
        WindowGroup {
            AppView(store: store) // Instantiate the AppView from the store of AppFeature
        }
    }
}
