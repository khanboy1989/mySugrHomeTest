//
//  CDMeasurement+CoreDataProperties.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 12/12/2024.
//

import Foundation
import CoreData

extension CDMeasurement {
    @NSManaged var id: UUID
    @NSManaged var createdAt: Date
    @NSManaged var mgPerL: Double
    @NSManaged var mmolPerL: Double
}
