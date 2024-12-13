//
//  String+Extensions.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 13/12/2024.
//

extension Double {
    /// Formats the double to a string with the specified number of decimal places.
    /// - Parameter decimalPlaces: Number of decimal places to format to. Defaults to 2.
    /// - Returns: A string representation of the double formatted to the given decimal places.
    func formatToString(with decimalPlaces: Int = 2) -> String {
        return String(format: "%.\(decimalPlaces)f", self)
    }
}
