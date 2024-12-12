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
        // Available within iOS 16 and onwards (NavigationStack)
        NavigationStack {
            VStack {
                Asset.Images.logo.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text(L10n.welcome)
                    .font(.custom(FontFamily.SFUIDisplay.medium.name, size: 16))
                
                Spacer()
            }.onAppear {
                store.send(.onAppear)
            }
        }
    }
}
