//
//  IntExtensionTests.swift
//  LightingKitTests
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
@testable import LightingKit

class IntExtensionTests: XCTestCase {
    func testSanitizeBrightnessReturns0ForNegativeValue() {
        let int = -50
        let brightness = int.sanitizedBrightness()
        XCTAssertEqual(brightness, 0)
    }
    func testSanitizeBrightnessReturns0For0Value() {
        let brightness = 0.sanitizedBrightness()
        XCTAssertEqual(brightness, 0)
    }
    func testSanitizeBrightnessReturns1000ForOver100Value() {
        let brightness = 101.sanitizedBrightness()
        XCTAssertEqual(brightness, 100)
    }
    func testSanitizeBrightnessReturns1000For100Value() {
        let brightness = 100.sanitizedBrightness()
        XCTAssertEqual(brightness, 100)
    }
    func testSanitizeBrightnessReturnsValidValue() {
        let brightness = 56.sanitizedBrightness()
        XCTAssertEqual(brightness, 56)
    }
}
