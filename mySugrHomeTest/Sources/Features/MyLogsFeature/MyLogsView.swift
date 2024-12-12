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
            VStack(spacing: 4) {
                Asset.Images.logo.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text(L10n.welcome)
                    .font(.custom(FontFamily.SFUIDisplay.medium.name, size: 16))
                Spacer().frame(height: 16)
                unitSelectionSection // UnitSelectionSection ViewBuilder
                Spacer()
            }.background(.white)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
    
    @ViewBuilder
    private var unitSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.pleaseSelectAnUnit)
                .font(.custom(FontFamily.SFUIDisplay.medium.name, size: 22))
                .foregroundStyle(Asset.Colors.textColor.swiftUIColor)
            HStack(spacing: 16) {
                ForEach(store.availableUnits) { unit in
                    RadioButtonView(title: unit.rawValue,
                                    isSelected: store.selectedUnit == unit)
                    .onTapGesture {
                        store.send(.selectUnit(unit))
                    }
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.leading, 16)
    }
}

#Preview {
    MyLogsView(store: Store(initialState: MyLogsFeature.State()){
        MyLogsFeature()
    })
}
