//
//  SuccessStrategyTests.swift
//  LightingKitTests
//
//  Created by Peter Morris on 23/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import XCTest
@testable import LightingKit

class SuccessStrategyTests: XCTestCase {
    var manager = MockHomeManager()
    var strategy = HomeKitPermissionSuccessStrategy()
    func testHomeKitPermissionSuccessStrategyReturnsFalseWhenPermissionNotGiven() {
        manager.shouldGrantPermission = false
        let success = strategy.success(manager: manager)
        XCTAssertFalse(success, "HomeKitPermissionSuccessStrategy success should return false when permissions not granted.")
    }
    func testHomeKitPermissionSuccessStrategyReturnsTrueWhenPermissionGiven() {
        manager.shouldGrantPermission = true
        let success = strategy.success(manager: manager)
        XCTAssertTrue(success, "HomeKitPermissionSuccessStrategy success should return true when permissions granted.")
    }
}
