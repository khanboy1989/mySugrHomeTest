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
    
    /*
     • mmol/L is the standard in the UK and most countries adhering to the SI system.
     
     • mg/dL is more common in the US and Japan.
     */
    var title: String {
        switch self {
        case .mmol:
            return L10n.mmoll
        case .mgdl:
            return L10n.mgdl
        }
    }
}
