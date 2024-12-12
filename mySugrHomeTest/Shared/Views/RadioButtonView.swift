//
//  RadioButtonView.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import Foundation
import SwiftUI

/*
 RadioButtonView is childview to be used when radio button
 UI is necessary, it does not contain any logic for Reusability
 and decoupling 
 */
struct RadioButtonView: View {
    var title: String
    // Not @Binding var isSelected because it is not a state to be changed from parentview
    var isSelected: Bool
    var body: some View {
        HStack {
            Circle()
                .stroke(Asset.Colors.skyBlue.swiftUIColor, lineWidth: 2)
                .frame(width: 20, height: 20)
                .background(
                    Circle()
                        .fill(isSelected ?
                              Asset.Colors.tangerineOrange.swiftUIColor : Color.clear)
                        .padding(4))
            Text(title)
                .font(.custom(FontFamily.SFUIDisplay.medium, size: 16))
                .foregroundStyle(Asset.Colors.textColor.swiftUIColor)
        }
    }
}

#Preview {
    RadioButtonView(title: "mg/L", isSelected: true)
}
