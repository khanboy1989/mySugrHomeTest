//
//  AppFeatureTests.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 12/12/2024.
//

import ComposableArchitecture
import XCTest

@testable import mySugrHomeTest

#warning("Re-check tests")
final class AppFeatureTests: XCTestCase {
    func testDatabasePrepSuccess() async {
        let store = await TestStore(initialState: AppFeature.State()) {
            AppFeature()
                ._printChanges()
        } withDependencies: {
            $0.persistenceClient.prepareDatabase = { try await Task.sleep(nanoseconds: 1_000_000_000) }
        }

        await store.send(.onAppear)
        
        await store.receive(\.databaseState, timeout: .nanoseconds(1_000_000_000)) {
            $0.databaseState = .ready
        }
    }
    
    func testDatabasePrepFailure() async {
        let store = await TestStore(initialState: AppFeature.State()) {
            AppFeature()
                ._printChanges()
        } withDependencies: {
            $0.persistenceClient.prepareDatabase = { throw AppError.databaseCorrupted("Could not load database") }
        }
        
        store.exhaustivity = .off(showSkippedAssertions: true)
        
        await store.send(.onAppear) {
            $0.databaseState = .loading
        }
        
        // Simulate the failure
        await store.receive(\.databaseState) {
            if case let .failed(error) = $0.databaseState {
                XCTAssertEqual(error, "Could not load database")
            }
        }
    }
}
