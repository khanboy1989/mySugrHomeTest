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
    
    func testUnitSelection() async {
        // Given: Logs with mgPerL and mmolPerL values
        let logs = [
            mySugrHomeTest.DailyLog(mgPerL: 12, mmolPerL: 0.67),
            mySugrHomeTest.DailyLog(mgPerL: 8, mmolPerL: 0.44)
        ]
        
        let store = await TestStore(initialState: MyLogsFeature.State(myLogs: logs)) {
            MyLogsFeature()
        }

        // When: Unit is switched to .mgdl
        await store.send(.selectUnit(.mgdl)) {
            $0.selectedUnit = .mgdl
        }
        
        // Then: Verify the average value calculation in mg/dL
        await store.receive(\.calculateAverage) {
            $0.averageBgValue = "10.0 mg/dl" // Average of mg/dL values (12 + 8) / 2
        }
    }
}
