//
//  LightingKitPermissionsTests.swift
//  LightingKitTests
//
//  Created by Peter Morris on 20/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
@testable import LightingKit

class LightingKitPermissionsTests: XCTestCase {
    
    var mockHomeManager: MockHomeManager!
    var permissions: LightingKitPermission!
    var completion: TestCompletion!
    var strategy: MockStrategy!

    override func setUp() {
        completion = TestCompletion()
        mockHomeManager = MockHomeManager()
        strategy = MockStrategy()
        permissions = LightingKitPermission(
            homeManager: self.mockHomeManager,
            strategy: strategy,
            permissionCompletion: completion.getCompletion()
        )
    }

    func testPermissionFailed() {
        strategy.shouldSucceed = false
        mockHomeManager.notifyDelegate()
        XCTAssertFalse(
            completion.complete,
            "LightingKitPermissions completion should return false when permission not granted."
        )
    }
    
    func testPermissionGranted() {
        strategy.shouldSucceed = true
        mockHomeManager.notifyDelegate()
        XCTAssertTrue(
            completion.complete,
            "LightingKitPermissings completion should return true when permission granted."
        )
    }

}
