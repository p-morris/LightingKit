//
//  CharacteristicExtensionTests.swift
//  LightingKitTests
//
//  Created by Peter Morris on 04/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
import HomeKit
@testable import LightingKit

class CharacteristicExtensionTests: XCTestCase {
    func testTypeReturnsPowerForPowerState() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypePowerState
        XCTAssertEqual(characteristic.type, .power)
    }
    func testTypeReturnsBrightnessForBrightnessType() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        XCTAssertEqual(characteristic.type, .brightness)
    }
    func testTypeReturnsUnknownForUnknownType() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeLogs
        XCTAssertEqual(characteristic.type, .unknown)
    }
}
