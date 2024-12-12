//
//  AppFeatureTests.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 12/12/2024.
//

import ComposableArchitecture
import XCTest

@testable import mySugrHomeTest

final class AppFeatureTests: XCTestCase {
    
    func testDatabasePrep() async {
        let store = await TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.persistenceClient.prepareDatabase = { }
        }
        
    }
}
