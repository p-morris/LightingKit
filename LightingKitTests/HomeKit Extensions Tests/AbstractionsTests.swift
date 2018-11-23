//
//  AbstractionsTests.swift
//  LightingKitTests
//
//  Created by Peter Morris on 23/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
@testable import LightingKit

class AbstractionsTests: XCTestCase {
    func testLightingKitObjectSetsPropertiesCorrectly() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let mockHomeKitObject = MockHomeKitObject(uniqueIdentifier: uuid, name: "")
        let light: Light = mockHomeKitObject.lightingKitObject()
        XCTAssert(light.name == mockHomeKitObject.name && light.id.uuidString == mockHomeKitObject.uniqueIdentifier.uuidString,
                  "HomeKitObject extensions lightingKitObject shiould return LightingKitObject with properties matching HomeKit object."
        )
    }
    func testCategoryIsLightingReturnsTrueForLighting() {
        let mockCategory = MockCategory()
        mockCategory.isLight = true
        XCTAssertTrue(mockCategory.isLighting, "HomeKitCategoryProtocol extension should return true when category type is lighting.")
    }
    func testCategoryIsLightingReturnsFalseForNonLighting() {
        let mockCategory = MockCategory()
        mockCategory.isLight = false
        XCTAssertFalse(
            mockCategory.isLighting,
            "HomeKitCategoryProtocol extension should return false when category type is not lighting."
        )
    }
}
