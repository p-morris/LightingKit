//
//  HomeManagerExtensionsTests.swift
//  LightingKitTests
//
//  Created by Peter Morris on 23/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
import HomeKit
@testable import LightingKit

class HomeManagerExtensionsTests: XCTestCase {
    func testPermissionGrantedReturnsFalseWhenNoHomeKitPermissions() {
        let manager = HMHomeManager()
        XCTAssertFalse(manager.permissionGranted, "HMHomeManager should return false when permissions not granted")
    }
}
