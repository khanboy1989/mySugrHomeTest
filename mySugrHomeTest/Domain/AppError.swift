//
//  AppError.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import Foundation

enum AppError: Error {
    case databaseCorrupted(String)
}

extension AppError: LocalizedError {
     var errorDescription: String? {
        switch self {
        case .databaseCorrupted(let message):
            return message
        }
    }
}
