//
//  ServiceExtensionTests.swift
//  LightingKitTests
//
//  Created by Peter Morris on 04/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
import HomeKit
@testable import LightingKit

class ServiceExtensionTests: XCTestCase {
    func testIsLightingReturnsTrueForLightbulbServiceType() {
        let mockService = MockService()
        mockService.testType = HMServiceTypeLightbulb
        XCTAssertTrue(mockService.isLighting, "Service extension should return true for light bulb type.")
    }
    func testIsLightingReturnsFalseForNonLightbulbServiceType() {
        let mockService = MockService()
        mockService.testType = HMServiceTypeSlats
        XCTAssertFalse(mockService.isLighting, "Service extension should return false for non light bulb type.")
    }
}
