//
//  PersistenceClient.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//
import CoreData
import Foundation
import ComposableArchitecture

struct PersistenceClient {
    var prepareDatabase: () async throws -> Void
    var recordLog: (DailyLog) async throws -> Void
    var fetchDaiLyLog: () async throws -> [DailyLog]
}

extension PersistenceClient {
    static let live: PersistenceClient = .init(prepareDatabase: { try await PersistenceController.shared.prepare() },
        recordLog: PersistenceController.shared.saveDailyLog,
        fetchDaiLyLog: PersistenceController.shared.fetchDailyMeasurements
    )
}

// Dependency Key for DI 
extension PersistenceClient: DependencyKey {
    static var liveValue: PersistenceClient = .live
}

// Dependency Value For Persistence Client
//inject as @Dependency(\.persistenceClient) var persistenceClient from Composable Architecture
extension DependencyValues {
    var persistenceClient: PersistenceClient {
        get { self[PersistenceClient.self] }
        set { self[PersistenceClient.self] = newValue }
    }
}
