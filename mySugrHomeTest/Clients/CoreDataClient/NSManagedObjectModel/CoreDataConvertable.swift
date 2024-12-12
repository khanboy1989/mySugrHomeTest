//
//  CoreDataConvertable.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 12/12/2024.
//

import Foundation
import CoreData

protocol CoreDataConvertable {
    associatedtype CoreDataObject: NSManagedObject, ModelConvertable
    @discardableResult
    func toCoreDataObject(in context: NSManagedObjectContext) -> CoreDataObject
}
