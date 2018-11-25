//
//  PowerTests.swift
//  LightingKitTests
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
import HomeKit
@testable import LightingKit

class PowerTests: XCTestCase {
    func testInitReturnsNilForNonPowerCharacteristic() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeHue
        let power = Power(homeKitCharacteristic: characteristic)
        XCTAssertNil(power, "Power init should return nil for non-power characteristics.")
    }
    func testInitReturnsPowerForPowerCharacteristic() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypePowerState
        let power = Power(homeKitCharacteristic: characteristic)
        XCTAssertNotNil(power, "Power init should return Power object for power characteristics.")
    }
    func testOnReturnsTrueForTrueValue() {
        let characteristic = MockCharacteristic()
        characteristic.value = true
        characteristic.characteristicType = HMCharacteristicTypePowerState
        let power = Power(homeKitCharacteristic: characteristic)!
        XCTAssertTrue(power.on, "Power on should return true for true characteristic value.")
    }
    func testOnReturnsFalseForFalseValue() {
        let characteristic = MockCharacteristic()
        characteristic.value = false
        characteristic.characteristicType = HMCharacteristicTypePowerState
        let power = Power(homeKitCharacteristic: characteristic)!
        XCTAssertFalse(power.on, "Power on should return false for false characteristic value.")
    }
    func testOnReturnsFalseForNonBoolValue() {
        let characteristic = MockCharacteristic()
        characteristic.value = "test"
        characteristic.characteristicType = HMCharacteristicTypePowerState
        let power = Power(homeKitCharacteristic: characteristic)!
        XCTAssertFalse(power.on, "Power on should return false for false characteristic value.")
    }
    func testOnWritesValue() {
        let characteristic = MockCharacteristic()
        characteristic.value = "test"
        characteristic.characteristicType = HMCharacteristicTypePowerState
        let power = Power(homeKitCharacteristic: characteristic)!
        power.on(true) { _ in }
        XCTAssertTrue(characteristic.didWriteValue, "Power on(_:completion) should write characteristic value.")
    }
    func testOnCallsCompletion() {
        let characteristic = MockCharacteristic()
        characteristic.value = "test"
        characteristic.characteristicType = HMCharacteristicTypePowerState
        let power = Power(homeKitCharacteristic: characteristic)!
        let completion = TestCompletion()
        power.on(true, completion: completion.getErrorCompletion())
        XCTAssertTrue(completion.complete, "Power on(_:completion) should execute completion.")
    }
}
