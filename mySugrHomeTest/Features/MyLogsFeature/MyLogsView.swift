//
//  MyLogsView.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import SwiftUI
import ComposableArchitecture

struct MyLogsView: View {
    // Bindable because we have to create binding option
    // between textfield and binding state
    @Bindable var store: StoreOf<MyLogsFeature>
    
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
                VStack(spacing: 16) {
                    unitSelectionSection // UnitSelectionSection ViewBuilder
                    unitEntryFieldSection // UnitEntryFieldSection for user input
                }
                
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
    
    @ViewBuilder
    private var unitEntryFieldSection: some View {
        HStack(alignment: .center) {
            TextField("", text: $store.bgValueText,
                      prompt: Text(L10n.pleaseEnterABGValue).foregroundStyle(.gray))
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 1)
                )
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(Asset.Colors.tangerineOrange.swiftUIColor)
            Button {
                store.send(.save)
            } label: {
                Text(L10n.save)
            }.buttonStyle(.borderedProminent)
        }.padding()
    }
}

#Preview {
    MyLogsView(store: Store(initialState: MyLogsFeature.State()){
        MyLogsFeature()
    })
}
