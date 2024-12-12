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
            assertionFailure("Unresolved error \(error)")
        }
    }
    
    func prepare() async throws {
        if !persistenceStoreLoaded {
            try await self.loadPersistenceStore()
            persistenceStoreLoaded = true
        }
    }
    
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
    
    func purgeEntity<T: NSManagedObject>(entityType: T.Type, predicate: NSPredicate, context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = entityType.fetchRequest()
        fetchRequest.predicate = predicate
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        context.performAndWait {
            _ = try? context.execute(batchDeleteRequest)
            saveContext(context)
        }
    }
    
    func purgeEntity<T: NSManagedObject>(entityType: T.Type, context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = entityType.fetchRequest()
        let batchDeleteRequest: NSBatchDeleteRequest = .init(fetchRequest: fetchRequest)
        context.performAndWait {
            do {
                _ = try context.execute(batchDeleteRequest)
            } catch {
                Log.error("Error purging entity: \(error.localizedDescription)", context: .db)
            }
            saveContext(context)
        }
    }
    
    func materializedObjects(context: NSManagedObjectContext, predicate: NSPredicate)
    -> [NSManagedObject]
    {
        
        context.performAndWait {
            var objects = [NSManagedObject]()
            for object in context.registeredObjects where !object.isFault {
                guard object.entity.attributesByName.keys.contains("uid"),
                      predicate.evaluate(with: object)
                else { continue }
                objects.append(object)
            }
            return objects
        }
    }
    
    func batchFetchDomainObject<T: NSManagedObject>(
        entityType: T.Type,
        fetchLimit: Int = 300,
        predicate: NSPredicate? = nil,
        findBeforeFetch: Bool = false,
        sortDescriptors: [NSSortDescriptor]? = nil,
        context: NSManagedObjectContext? = nil
    ) -> [T.ModelType] where T: ModelConvertable {
        let context = context ?? container.newBackgroundContext()
        return batchFetch(
            entityType: entityType,
            fetchLimit: fetchLimit,
            predicate: predicate,
            findBeforeFetch: findBeforeFetch,
            sortDescriptors: sortDescriptors,
            context: context
        ).toModel(context: context)
    }
    
    func batchFetch<T: NSManagedObject>(
        entityType: T.Type,
        fetchLimit: Int = 100,
        predicate: NSPredicate? = nil,
        findBeforeFetch: Bool = false,
        sortDescriptors: [NSSortDescriptor]? = nil,
        context: NSManagedObjectContext
    ) -> [T] {
        var results = [T]()
        results = context.performAndWait {
            if findBeforeFetch, let predicate = predicate {
                if let objects = materializedObjects(context: context, predicate: predicate)
                    as? [T],
                   !objects.isEmpty
                {
                    results = objects
                }
            }
            let request = NSFetchRequest<T>(
                entityName: String(describing: entityType)
            )
            request.predicate = predicate
            request.fetchLimit = fetchLimit
            request.sortDescriptors = sortDescriptors
            
            results = (try? fetch(request, context: context)) ?? []
            return results
        }
        return results
    }
    
    func fetch<T>(
        _ request: NSFetchRequest<T>,
        context: NSManagedObjectContext
    ) throws -> [T] where T: NSFetchRequestResult {
        try context.performAndWait {
            try context.fetch(request)
        }
        
    }
    
    func fetch<T: NSManagedObject>(
        entityType: T.Type,
        predicate: NSPredicate? = nil,
        findBeforeFetch: Bool = false,
        commitChanges: ((T?) -> Void)? = nil,
        context: NSManagedObjectContext
    ) -> T? {
        return context.performAndWait {
            let managedObject = batchFetch(
                entityType: entityType, fetchLimit: 1,
                predicate: predicate, findBeforeFetch: findBeforeFetch,
                context: context
            ).first
            commitChanges?(managedObject)
            return managedObject
        }
    }
    
    func fetchOrCreate<T: NSManagedObject>(
        entityType: T.Type,
        predicate: NSPredicate? = nil,
        commitChanges: ((T?) -> Void)? = nil,
        context: NSManagedObjectContext
    ) -> T {
        if let storedCoreDataObject: T = fetch(
            entityType: entityType,
            predicate: predicate,
            context: context
        ) {
            return storedCoreDataObject
        } else {
            return context.performAndWait {
                let newT = T(context: context)
                commitChanges?(newT)
                saveContext(context)
                return newT
            }
            
        }
    }
    
    func fetchModelObject<T: NSManagedObject>(
        entityType: T.Type,
        predicate: NSPredicate? = nil,
        findBeforeFetch: Bool = false,
        commitChanges: ((T?) -> Void)? = nil,
        contextToUse: NSManagedObjectContext? = nil
    ) -> T.ModelType? where T: ModelConvertable {
        
        let context = contextToUse ?? container.viewContext
        
        return fetch(
            entityType: entityType,
            predicate: predicate,
            findBeforeFetch: findBeforeFetch,
            commitChanges: commitChanges,
            context: context
        )?.toModel(context: context)
    }
    
    func batchUpdate<T: NSManagedObject>(
        entityType: T.Type,
        predicate: NSPredicate? = nil,
        commitChanges: ([T]) -> Void,
        context: NSManagedObjectContext
    ) {
        context.performAndWait {
            commitChanges(
                batchFetch(
                    entityType: entityType,
                    predicate: predicate,
                    findBeforeFetch: false,
                    context: context
                ))
            saveContext(context)
        }
    }
    
    func update<T: NSManagedObject>(
        entityType: T.Type,
        predicate: NSPredicate? = nil,
        createIfNil: Bool = true,
        commitChanges: @escaping (T?) -> Void,
        context: NSManagedObjectContext? = nil
    ) {
        let context = context ?? container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.perform {
            let storedT: T?
            if createIfNil {
                storedT = self.fetchOrCreate(entityType: entityType, predicate: predicate, context: context)
            } else {
                storedT = self.fetch(entityType: entityType, predicate: predicate, context: context)
            }
            
            if let storedT = storedT {
                context.performAndWait {
                    commitChanges(storedT)
                    self.saveContext(context)
                }
            }
        }
    }
}


extension PersistenceController {
    func saveDailyLog(_ log: DailyLog) async {
        let context = container.newBackgroundContext()
        _ = log.toCoreDataObject(in: context)
        self.saveContext(context)
    }
    
    func fetchDailyMeasurements() async throws -> [DailyLog] {
        let context = container.newBackgroundContext()
        let dailyLogs = batchFetchDomainObject(entityType: CDMeasurement.self, context: context)
        return dailyLogs
    }
}
