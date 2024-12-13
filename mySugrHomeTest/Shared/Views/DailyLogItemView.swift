//
//  DailyLogItemView.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 12/12/2024.
//

import SwiftUI

struct DailyLogItemView: View {
    let dailyLog: DailyLog
    let selectedUnit: UnitType
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(formatValue(dailyLog, unit: selectedUnit)) // Display the value
                    .font(.custom(FontFamily.SFUIDisplay.medium, size: 16))
                    .foregroundStyle(Asset.Colors.tangerineOrange.swiftUIColor)
                Text(dailyLog.formattedDate) // Display the date and time
                    .font(.custom(FontFamily.SFUIDisplay.thin, size: 14))
                    .foregroundColor(Asset.Colors.subtleGray.swiftUIColor)
            }
            
            Spacer() // Push content to the left
            
            Text(selectedUnit.title) // Display the unit
                .font(.custom(FontFamily.SFUIDisplay.light, size: 14))
                .foregroundColor(Asset.Colors.skyBlue.swiftUIColor)
        }
        .padding()
    }
    
    // Helper to format the value based on the unit
    private func formatValue(_ log: DailyLog, unit: UnitType) -> String {
        switch unit {
        case .mgdl:
            return "\(log.mgPerL.formatToString(with: 1)) \(L10n.mgdl)" // One decimal point for mg/dL
        case .mmol:
            return "\(log.mmolPerL.formatToString(with: 1)) \(L10n.mmoll)" // One decimal point for mmol/L
        }
    }
}
