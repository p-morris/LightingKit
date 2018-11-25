//
//  BrightnessTests.swift
//  LightingKitTests
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
import HomeKit
@testable import LightingKit

class BrightnessTests: XCTestCase {
    func testInitReturnsNilForNonBrightnessCharacteristic() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypePowerState
        let brightness = Brightness(homeKitCharacteristic: characteristic)
        XCTAssertNil(brightness, "Brightness init should return nil for non-brightness characteristic.")
    }
    func testInitReturnsObjectForBrightnessCharacteristic() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        let brightness = Brightness(homeKitCharacteristic: characteristic)
        XCTAssertNotNil(brightness, "Brightness init should return object for brightness characteristic.")
    }
    func testValueReturnsNilWhenNoValueAvailable() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        let brightness = Brightness(homeKitCharacteristic: characteristic)
        XCTAssertNil(brightness?.value, "Brightness value should return nil when brightness value not set.")
    }
    func testValueReturnsCorrectValue() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        characteristic.value = 100
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        XCTAssert(brightness.value != nil && brightness.value == 100, "Brightness value should return correct value when set.")
    }
    func testSetWritesNewValue() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        brightness.set(brightness: 100) { _ in }
        XCTAssertTrue(characteristic.didWriteValue, "Brightness set(_:completion) should set characteristic value.")
    }
    func testSetExecutesCompletion() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let completion = TestCompletion()
        brightness.set(brightness: 100, completion: completion.getErrorCompletion())
        XCTAssertTrue(completion.complete, "Brightness set(_:completion) should execute completion.")
    }
}
