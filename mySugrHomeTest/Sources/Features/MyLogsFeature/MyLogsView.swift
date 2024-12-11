//
//  MyLogsView.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import SwiftUI
import ComposableArchitecture

struct MyLogsView: View {
    let store: StoreOf<MyLogsFeature>
    
    var body: some View {
        VStack {
            Text("Welcome to my logs view ")
        }.onAppear {
            store.send(.onAppear)
        }
    }
}
