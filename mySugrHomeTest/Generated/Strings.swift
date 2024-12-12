// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Error
  internal static let error = L10n.tr("Localizable", "error", fallback: "Error")
  /// mg/dl
  internal static let mgdl = L10n.tr("Localizable", "mgdl", fallback: "mg/dl")
  /// mmol/L
  internal static let mmoll = L10n.tr("Localizable", "mmoll", fallback: "mmol/L")
  /// Localizable.strings
  ///   mySugrHomeTest
  /// 
  ///   Created by Serhan Khan on 11/12/2024.
  internal static let ok = L10n.tr("Localizable", "ok", fallback: "Ok")
  /// Please enter a blood glucose value
  internal static let pleaseEnterABGValue = L10n.tr("Localizable", "pleaseEnterABGValue", fallback: "Please enter a blood glucose value")
  /// Please select an unit
  internal static let pleaseSelectAnUnit = L10n.tr("Localizable", "pleaseSelectAnUnit", fallback: "Please select an unit")
  /// Please wait
  internal static let pleaseWait = L10n.tr("Localizable", "pleaseWait", fallback: "Please wait")
  /// Save
  internal static let save = L10n.tr("Localizable", "save", fallback: "Save")
  /// Welcome to Logbook Application
  internal static let welcome = L10n.tr("Localizable", "welcome", fallback: "Welcome to Logbook Application")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
