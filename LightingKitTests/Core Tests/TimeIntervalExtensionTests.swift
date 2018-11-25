//
//  TimeIntervalExtensionTests.swift
//  LightingKitTests
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
@testable import LightingKit

class TimeIntervalExtensionTests: XCTestCase {
    func testIncrementForHigherBrightness() {
        let duration = TimeInterval(10)
        let interval = duration.incrementInterval(currentBrightness: 10, targetBrightness: 20)
        XCTAssertEqual(interval, 1, "TimeInterval incrementInterval should return correct interval for positive change.")
    }
    func testIncrementForLowerBrightness() {
        let duration = TimeInterval(10)
        let interval = duration.incrementInterval(currentBrightness: 20, targetBrightness: 10)
        XCTAssertEqual(interval, 1, "TimeInterval incrementInterval should return correct interval for negative change.")
    }
}
