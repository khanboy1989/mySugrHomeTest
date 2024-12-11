//
//  NSManagedObjectModel+Resorce.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import CoreData
import Foundation

/*
 Why Check Both?
     1.    Ensure Compatibility:
     •    Some environments or build configurations might only generate .mom files, while others include .omo files.
     •    By checking both, the code ensures that the model can still be loaded regardless of which file format is available.
     2.    Fallback for Missing .omo:
     •    If the .omo file is missing or not generated (e.g., in non-optimized builds or older Xcode versions), the code falls back to loading the .mom file.
     3.    Resilience in Different Scenarios:
     •    Development builds might include .mom only, while production builds include .omo.
     •    Ensuring both are checked adds robustness to the model-loading process.
 */
extension NSManagedObjectModel {
    static func managedObjectModel(forResourse resource: String) throws -> NSManagedObjectModel {
        let omoUrl = Bundle.main.url(forResource: resource, withExtension: "omo", subdirectory: CDConstants.subdirectory)
        let momUrl = Bundle.main.url(forResource: resource, withExtension: "mom", subdirectory: CDConstants.subdirectory)
        
        guard let url =  omoUrl ?? momUrl else {
            throw AppError.databaseCorrupted("Unable to find model in bundle.")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
          throw AppError.databaseCorrupted("Unable to load model in bundle.")
        }
        
        return model
   }
}
