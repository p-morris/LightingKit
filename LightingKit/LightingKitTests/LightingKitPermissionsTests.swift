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
    var strategy: MockSuccessStrategy!

    override func setUp() {
        completion = TestCompletion()
        mockHomeManager = MockHomeManager()
        strategy = MockSuccessStrategy()
        permissions = LightingKitPermission(strategy: strategy)
    }

    func testPermissionFailed() {
        strategy.shouldSucceed = false
        permissions.requestPermission(homeManager: mockHomeManager, completion: completion.getCompletion())
        mockHomeManager.notifyDelegate()
        XCTAssertFalse(
            completion.complete,
            "LightingKitPermissions completion should return false when permission not granted."
        )
    }
    
    func testPermissionGranted() {
        strategy.shouldSucceed = true
        permissions.requestPermission(homeManager: mockHomeManager, completion: completion.getCompletion())
        mockHomeManager.notifyDelegate()
        XCTAssertTrue(
            completion.complete,
            "LightingKitPermissings completion should return true when permission granted."
        )
    }
    
    func testDidUpdateRemovesDelegate() {
        permissions.requestPermission(homeManager: mockHomeManager, completion: completion.getCompletion())
        mockHomeManager.notifyDelegate()
        XCTAssertNil(mockHomeManager.delegate, "LightingKitPermissions should set delegate to nil on completion.")
    }

}
