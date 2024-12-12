//
//  CD.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 12/12/2024.
//

import Foundation
import CoreData

@objc(CDMeasurement)
class CDMeasurement: NSManagedObject {}

extension CDMeasurement: ModelConvertable {
    func toModel(context: NSManagedObjectContext) -> DailyLog {
        context.performAndWait {
            DailyLog(id: self.id,
                     dateAdded: self.createdAt,
                     mgPerL: Double(self.mgPerL),
                     mmolPerL: Double(self.mmolPerL))
        }
    }
}

extension DailyLog: CoreDataConvertable {
    func toCoreDataObject(in context: NSManagedObjectContext) -> CDMeasurement {
        let mesaurement = CDMeasurement(context: context)
        mesaurement.id = id
        mesaurement.createdAt = dateAdded
        mesaurement.mgPerL = mgPerL
        mesaurement.mmolPerL = mmolPerL
        return mesaurement
    }
}
