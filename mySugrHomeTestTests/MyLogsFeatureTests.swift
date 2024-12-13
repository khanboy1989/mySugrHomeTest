//
//  MyLogsFeatureTests.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 13/12/2024.
//

import ComposableArchitecture
import XCTest
@testable import mySugrHomeTest

final class MyLogsFeatureTests: XCTestCase {
    
    //Tests the selectUnit
    func testUnitSelection() async {
        let store = await TestStore(initialState: MyLogsFeature.State()) {
            MyLogsFeature()
        }
        store.exhaustivity = .off(showSkippedAssertions: true)
        await store.send(.selectUnit(.mgdl)) {
            $0.selectedUnit = .mgdl
        }
    }
}
