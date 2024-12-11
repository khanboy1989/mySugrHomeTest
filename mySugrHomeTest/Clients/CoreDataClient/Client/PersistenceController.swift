//
//  PersistenceController.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import CoreData
import Foundation

/*
 A mapping model defines how data is transformed from one version of a Core Data model to another. This includes:
 •    Mapping entities and attributes between versions.
 •    Handling renamed, added, or deleted attributes and entities.
 */
class PersistenceController {
    static let shared: PersistenceController = .init()
    var persistenceStoreLoaded: Bool = false
    
    let container: NSPersistentContainer = {
        let objectModel = try! NSManagedObjectModel.managedObjectModel(forResourse: CDConstants.model)
        let container: NSPersistentContainer = NSPersistentContainer(name: CDConstants.model, managedObjectModel: objectModel)
        let description = container.persistentStoreDescriptions.first
        description?.shouldInferMappingModelAutomatically = true
        description?.shouldMigrateStoreAutomatically = true
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
}

extension PersistenceController {
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            Log.error(error, context: .db)
        }
    }
    
    // Prepares the database 
    func prepare() async throws {
        if !persistenceStoreLoaded {
            try await self.loadPersistenceStore()
            persistenceStoreLoaded = true
        }
    }
    
    // Loads the store from container
    private func loadPersistenceStore() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            container.loadPersistentStores { description, error in
                guard error == nil else {
                    Log.error("Was unable to load store: \(error!.localizedDescription)", context: .db)
                    continuation.resume(throwing: AppError.databaseCorrupted("Was unable to load store"))
                    return
                }
                Log.debug("Persistence store loaded: \(description)", context: .db)
                continuation.resume()
            }
        }
    }
}
