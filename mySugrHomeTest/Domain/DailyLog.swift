//
//  Log.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 12/12/2024.
//

import Foundation

// DailyLog Model for View
struct DailyLog: Identifiable, Equatable {
    let id: UUID
    let dateAdded: Date
    let mgPerL: Double
    let mmolPerL: Double
    
    init(id: UUID = UUID(),dateAdded: Date = Date(), mgPerL: Double, mmolPerL: Double) {
        self.id = id
        self.dateAdded = dateAdded
        self.mgPerL = mgPerL
        self.mmolPerL = mmolPerL
    }
    
    var formattedDate: String {
        return dateAdded.formatDate()
    }
}
