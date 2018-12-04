//
//  CategoryExtensionTests.swift
//  LightingKitTests
//
//  Created by Peter Morris on 04/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
import HomeKit
@testable import LightingKit

class CategoryExtensionTests: XCTestCase {
    func testTypeReturnsLightingForLightBulbType() {
        let category = MockCategory()
        category.testType = HMAccessoryCategoryTypeLightbulb
        XCTAssertEqual(category.type, .lighting, "Category extension type should return .lighting for a lightbulb.")
    }
    func testTypeReturnsBridgeForBridgeType() {
        let category = MockCategory()
        category.testType = HMAccessoryCategoryTypeBridge
        XCTAssertEqual(category.type, .bridge, "Category extension type should return .bridge for a bridge.")
    }
    func testTypeReturnsOtherForOtherType() {
        let category = MockCategory()
        category.testType = HMAccessoryCategoryTypeOther
        XCTAssertEqual(category.type, .other, "Category extension type should return .bridge for a bridge.")
    }
}
