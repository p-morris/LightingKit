//
//  LightingKitBrowserTests.swift
//  LightingKitTests
//
//  Created by Peter Morris on 23/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
import HomeKit
@testable import LightingKit

class LightingKitBrowserTests: XCTestCase {
    var mockBrowser: MockAccessoryBrowser!
    var lightingBrowser: LightingBrowser!
    override func setUp() {
        mockBrowser = MockAccessoryBrowser()
        lightingBrowser = LightingBrowser(browser: mockBrowser)
    }
    func testLightingBrowserInitSetsDelegate() {
        XCTAssertNotNil(mockBrowser.delegate, "LightingBrowser init should set accessory browser delegate.")
    }
    func testStartStopsBrowesr() {
        lightingBrowser.findNewLights { _ in }
        XCTAssertTrue(mockBrowser.stopped, "LightingBrowser findNewLights should stop accessory browser first.")
    }
    func testStartSetsCompletion() {
        lightingBrowser.findNewLights { _ in }
        XCTAssertNotNil(lightingBrowser.completion, "LightingBrowser findNewLights should should retain completion.")
    }
    func testStartStartsAccessoryBrowser() {
        lightingBrowser.findNewLights { _ in }
        XCTAssertTrue(mockBrowser.started, "LightingBrowser findNewLights should start accessory browser.")
    }
    func testStopStopsBrowser() {
        lightingBrowser.stop()
        XCTAssertTrue(mockBrowser.stopped, "LightingBrowser stop should stop the accessory browser instance.")
    }
    func testStopNullifiesCompletion() {
        lightingBrowser.findNewLights { _ in }
        lightingBrowser.stop()
        XCTAssertNil(lightingBrowser.completion, "LightingBrowser stop should nullify completion property.")
    }
}
