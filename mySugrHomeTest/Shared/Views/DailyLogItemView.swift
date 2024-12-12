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
                Text(dailyLog.formattedDate) // Display the date and time
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(formatValue(dailyLog, unit: selectedUnit)) // Display the value
                    .font(.headline)
            }
            
            Spacer() // Push content to the left
            
            Text(selectedUnit.rawValue) // Display the unit
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .padding()
    }
    
    // Helper to format the value based on the unit
    private func formatValue(_ log: DailyLog, unit: UnitType) -> String {
        switch unit {
        case .mgdl:
            return "\(Int(log.mgPerL)) mg/dL"
        case .mmol:
            return String(format: "%.1f mmol/L", log.mmolPerL)
        }
    }
}
