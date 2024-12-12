//
//  UnitType.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 12/12/2024.
//

import Foundation

enum UnitType: String, CaseIterable, Identifiable {
    case mmol = "mmol/L"
    case mgdl = "mg/dl"
    var id: String { rawValue }
    
//    var title: String {
//        switch self {
//            case .mmol
//        }
//    }
}
