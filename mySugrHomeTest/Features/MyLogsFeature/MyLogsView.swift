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
                averageTextView()
                Spacer().frame(height: 16)
                VStack(spacing: 16) {
                    unitSelectionSection // UnitSelectionSection ViewBuilder
                    unitEntryFieldSection // UnitEntryFieldSection for user input
                    saveButtonView()
                }
                
                List {
                    ForEach(store.myLogs, id: \.id) { log in
                        DailyLogItemView(dailyLog: log, selectedUnit: store.selectedUnit)
                            .padding(.vertical, 8) // Add vertical padding between cards
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white) // Card background color
                                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Card shadow
                            )
                            .padding(.horizontal) // Add horizontal spacing for each card
                            .listRowSeparator(.hidden) // Hide separators for the row
                            .listRowBackground(Color.clear) // Ensure background is clear for the card effect
                            
                    }
                }
                .listStyle(PlainListStyle()) // Plain style to remove grouped appearance
                .background(Asset.Colors.backgroundColor.swiftUIColor.ignoresSafeArea()) // Set overall List background
                .scrollDismissesKeyboard(.interactively) // Dismisses the keyboard when scrolled from bottom to top 
                
            }.background(.white)
                .onAppear {
                    store.send(.onAppear)
                }
        }.alert($store.scope(state: \.alert, action: \.alert)) //Alert modifier to display alerts dynamically when state is updated
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
        HStack(alignment: .center, spacing: 8) {
            TextField("", text: $store.bgValueText,
                      prompt: Text(L10n.pleaseEnterABGValue).foregroundStyle(.gray))
            .keyboardType(.numberPad)
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
            
            Text(store.selectedUnit.rawValue)
                .font(.custom(FontFamily.SFUIDisplay.light, size: 16))
        }.padding()
    }
    
    func saveButtonView() -> some View {
        ZStack {
            LoadingIndicator()
                .opacity(store.isSaving ? 1 : 0)
            Button {
                store.send(.save)
            } label: {
                Text(L10n.save)
                    .font(.custom(FontFamily.SFUIDisplay.medium, size: 20))
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
            }.buttonStyle(.borderedProminent)
                .padding(.horizontal, 16)
                .disabled(store.saveButtonDisabled)
                .opacity(store.isSaving ? 0 : 1)
        }
    }
    
    func averageTextView() -> some View {
        VStack {
            Text("\(L10n.yourAverageIs) \(store.averageBgValue)")
                .font(.custom(FontFamily.SFUIDisplay.medium, size: 16))
                .foregroundStyle(Asset.Colors.tangerineOrange.swiftUIColor)
            
            Divider()
                .frame(height: 1)
                .foregroundStyle(Asset.Colors.skyBlue.swiftUIColor)
        }
        
    }
}

#Preview {
    MyLogsView(store: Store(initialState: MyLogsFeature.State()){
        MyLogsFeature()
    })
}
