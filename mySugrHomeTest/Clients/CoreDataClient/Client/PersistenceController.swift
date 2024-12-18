//
//  PersistenceController.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import CoreData
import Foundation

/*
 PersistenceController manages Core Data stack operations, such as saving,
 fetching, and preparing the persistent store. It includes utilities for
 mapping Core Data objects to domain-specific models.
 */
class PersistenceController {
    static let shared: PersistenceController = .init()
    var persistenceStoreLoaded: Bool = false

    // MARK: - Persistent Container Setup
    let container: NSPersistentContainer = {
        // Load the Core Data model
        let objectModel = try! NSManagedObjectModel.managedObjectModel(forResourse: CDConstants.model)
        let container = NSPersistentContainer(name: CDConstants.model, managedObjectModel: objectModel)

        // Configure persistent store description
        let description = container.persistentStoreDescriptions.first
        description?.shouldInferMappingModelAutomatically = true
        description?.shouldMigrateStoreAutomatically = true

        return container
    }()

    // Context for UI-related operations
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
}

// MARK: - Core Data Operations
extension PersistenceController {
    /// Saves changes to the provided context.
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            Log.error(error, context: .db)
            assertionFailure("Unresolved error \(error)")
        }
    }

    /// Prepares the persistent store asynchronously.
    func prepare() async throws {
        if !persistenceStoreLoaded {
            try await self.loadPersistenceStore()
            persistenceStoreLoaded = true
        }
    }

    /// Loads the persistent store, handling errors.
    private func loadPersistenceStore() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            container.loadPersistentStores { description, error in
                guard error == nil else {
                    Log.error("Failed to load store: \(error!.localizedDescription)", context: .db)
                    continuation.resume(throwing: AppError.databaseCorrupted("Failed to load store"))
                    return
                }
                Log.debug("Persistent store loaded: \(description)", context: .db)
                continuation.resume()
            }
        }
    }

    /// Fetches Core Data objects and materializes only fully initialized ones.
    func materializedObjects(context: NSManagedObjectContext, predicate: NSPredicate) -> [NSManagedObject] {
        context.performAndWait {
            var objects = [NSManagedObject]()
            for object in context.registeredObjects where !object.isFault {
                guard predicate.evaluate(with: object) else { continue }
                objects.append(object)
            }
            return objects
        }
    }

    /// Fetches and converts domain objects using a generic fetcher.
    func batchFetchDomainObject<T: NSManagedObject>(
        entityType: T.Type,
        fetchLimit: Int = 300,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        context: NSManagedObjectContext? = nil
    ) throws -> [T.ModelType] where T: ModelConvertable {
        let context = context ?? container.newBackgroundContext()
        return try batchFetch(
            entityType: entityType,
            fetchLimit: fetchLimit,
            predicate: predicate,
            sortDescriptors: sortDescriptors,
            context: context
        ).toModel(context: context)
    }

    /// Performs a batch fetch for a specific Core Data entity type.
    func batchFetch<T: NSManagedObject>(
        entityType: T.Type,
        fetchLimit: Int = 100,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        context: NSManagedObjectContext
    ) throws -> [T] {
        return try context.performAndWait {
            let request = NSFetchRequest<T>(entityName: String(describing: entityType))
            request.predicate = predicate
            request.fetchLimit = fetchLimit
            request.sortDescriptors = sortDescriptors
            return (try context.fetch(request))
        }
    }
}

// MARK: - Save and Fetch Daily Logs
extension PersistenceController {
    /// Saves a DailyLog to Core Data.
    func saveDailyLog(_ log: DailyLog) async {
        let context = container.newBackgroundContext()
        _ = log.toCoreDataObject(in: context) // Convert to Core Data object
        self.saveContext(context) // Save the context
    }

    /// Fetches all saved DailyLog measurements.
    func fetchDailyMeasurements() async throws -> [DailyLog] {
        let context = container.newBackgroundContext()
        return try batchFetchDomainObject(entityType: CDMeasurement.self, context: context)
    }
    
    // MARK: - Streaming Fetch Results
    func dailyLogStream(predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> AsyncThrowingStream<[DailyLog], Error> {
        return AsyncThrowingStream { continuation in
            let context = container.newBackgroundContext()
            
            func fetchAndYield() {
                context.perform {
                    do {
                        let results: [DailyLog] = try self.batchFetchDomainObject(
                            entityType: CDMeasurement.self,
                            predicate: predicate,
                            sortDescriptors: sortDescriptors,
                            context: context)
                        continuation.yield(results)
                    } catch {
                        continuation.finish(throwing: error)
                    }
                }
            }

        }
    }
}
