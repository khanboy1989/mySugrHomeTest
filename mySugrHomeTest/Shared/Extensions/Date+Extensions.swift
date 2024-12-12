//
//  Date+Extensions.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 12/12/2024.
//

import Foundation

extension Date {
    // DateFormatter function to format the date
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Choose the desired date format
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
