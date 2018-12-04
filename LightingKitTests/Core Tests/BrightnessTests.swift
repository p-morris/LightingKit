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
    override func tearDown() {
        MockTimer.wasScheduled = false
        MockTimer.wasInvalidated = false
    }
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
    func testTimedBrightnessInvalidatesPendingTimer() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 0, end: 100, duration: 1, delegate: delegate, timerType: MockTimer.self)
        brightness.set(brightness: 50, duration: 20, brightnessDelegate: delegate)
        XCTAssertTrue(MockTimer.wasInvalidated, "Brightness timed update should invalidate scheduled timers.")
    }
    func testTimedBrightnessNotifiesDelegateIfDurationZero() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.set(brightness: 10, duration: 0, brightnessDelegate: delegate)
        XCTAssertTrue(delegate.updateFailed, "Brightness timed update should fail if brightness zero.")
    }
    func testTimedUpdateNotifiesDelegateIfNoCurrentBrightnessValue() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.set(brightness: 10, duration: 10, brightnessDelegate: delegate)
        XCTAssertTrue(delegate.updateFailed, "Brightness timed update should fail if brightness zero.")
    }
    func testUpdateTimedBrightnessInvalidatesTimerWhenNoTargetBrightness() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 0, end: 100, duration: 1, delegate: delegate, timerType: MockTimer.self)
        brightness.targetBrightness = nil
        brightness.updateTimedBrightness()
        XCTAssertTrue(MockTimer.wasInvalidated, "Brightness updateTimedBrightness should invalidate timer when no target brightness set.")
    }
    func testUpdateTimedBrightnessInvalidatesTimerWhenNoStartingBrightness() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 0, end: 100, duration: 1, delegate: delegate, timerType: MockTimer.self)
        brightness.startingBrightness = nil
        brightness.updateTimedBrightness()
        XCTAssertTrue(
            MockTimer.wasInvalidated,
            "Brightness updateTimedBrightness should invalidate timer when no starting brightness set."
        )
    }
    func testUpdateTimedBrightnessInvalidatesTimerWhenNoCurrentValue() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        characteristic.value = nil
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 0, end: 100, duration: 1, delegate: delegate, timerType: MockTimer.self)
        brightness.updateTimedBrightness()
        XCTAssertTrue(
            MockTimer.wasInvalidated,
            "Brightness updateTimedBrightness should invalidate timer when current value can't be accessed."
        )
    }
    func testUpdateTimedBrightnessNotifiesDelegateWhenNoCurrentValue() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        characteristic.value = nil
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 0, end: 100, duration: 1, delegate: delegate, timerType: MockTimer.self)
        brightness.updateTimedBrightness()
        XCTAssertTrue(
            delegate.updateFailed,
            "Brightness updateTimedBrightness should notify delegate when current value can't be accessed."
        )
    }
    func testUpdateTimedBrightnessNotifiesDelegateWhenTargetReached() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        characteristic.value = 10
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 0, end: 100, duration: 1, delegate: delegate, timerType: MockTimer.self)
        brightness.targetBrightness = 100
        characteristic.value = 100
        brightness.updateTimedBrightness()
        XCTAssertTrue(
            delegate.didComplete,
            "Brightness updateTimedBrightness should notify delegate when target reached."
        )
    }
    func testUpdateTimedBrightnessInvalidatesTimerWhenTargetReached() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        characteristic.value = 10
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 0, end: 100, duration: 1, delegate: delegate, timerType: MockTimer.self)
        brightness.targetBrightness = 100
        characteristic.value = 100
        brightness.updateTimedBrightness()
        XCTAssertTrue(
            MockTimer.wasInvalidated,
            "Brightness updateTimedBrightness should notify delegate when target reached."
        )
    }
    func testUpdateTimedBrightnessIncrementsValueCorrectly() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        characteristic.value = 10
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 10, end: 100, duration: 1, delegate: delegate, timerType: MockTimer.self)
        brightness.updateTimedBrightness()
        XCTAssertEqual(
            characteristic.value as! Int, 11,
            "Brightness updateTimedBrightness should increment brightness when target is greater than current brightness."
        )
    }
    func testUpdateTimedBrightnessDecrementsValueCorrectly() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        characteristic.value = 100
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 100, end: 0, duration: 1, delegate: delegate, timerType: MockTimer.self)
        brightness.updateTimedBrightness()
        XCTAssertEqual(
            characteristic.value as! Int, 99,
            "Brightness updateTimedBrightness should decrement brightness when target is lower than current brightness."
        )
    }
    func testBrightnessIncrementedNotifiesDelegateOnError() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        characteristic.value = 100
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 100, end: 0, duration: 1, delegate: delegate, timerType: MockTimer.self)
        brightness.brightnessIncremented(error: NSError(domain: "", code: 0, userInfo: nil))
        XCTAssertTrue(delegate.updateFailed, "Brightness brightnessIncremented should notify delegate on error")
    }
    func testBrightnessIncrementedInvalidatesTimerOnError() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        characteristic.value = 100
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 100, end: 0, duration: 1, delegate: delegate, timerType: MockTimer.self)
        brightness.brightnessIncremented(error: NSError(domain: "", code: 0, userInfo: nil))
        XCTAssertTrue(MockTimer.wasInvalidated, "Brightness brightnessIncremented should invalidete timer on error")
    }
    func testBrightnessIncrementedInvalidatesTimerWhenValueInaccessible() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        characteristic.value = 100
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 100, end: 0, duration: 1, delegate: delegate, timerType: MockTimer.self)
        characteristic.value = nil
        brightness.brightnessIncremented(error: nil)
        XCTAssertTrue(MockTimer.wasInvalidated, "Brightness brightnessIncremented should invalidete timer on error")
    }
    func testBrightnessIncrementedNotifiesDelegateOnValueInaccessible() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        characteristic.value = 100
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 100, end: 0, duration: 1, delegate: delegate, timerType: MockTimer.self)
        characteristic.value = nil
        brightness.brightnessIncremented(error: nil)
        XCTAssertTrue(delegate.updateFailed, "Brightness brightnessIncremented should notify delegate on error")
    }
    func testBrightnessIncrementedNotifiesDelegateOnBrightnessUpdate() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        characteristic.value = 100
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 100, end: 0, duration: 1, delegate: delegate, timerType: MockTimer.self)
        brightness.brightnessIncremented(error: nil)
        XCTAssertTrue(delegate.didChange, "Brightness brightnessIncremented should notify delegate when brightness changes.")
    }
    func testBrightnessCancelInvalidatesTimer() {
        let characteristic = MockCharacteristic()
        characteristic.characteristicType = HMCharacteristicTypeBrightness
        characteristic.value = 100
        let brightness = Brightness(homeKitCharacteristic: characteristic)!
        let delegate = MockBrightnessDelegate()
        brightness.scheduleBrightnessTimer(start: 100, end: 0, duration: 1, delegate: delegate, timerType: MockTimer.self)
        brightness.cancelTimedBrightnessUpdate()
        XCTAssertTrue(MockTimer.wasInvalidated, "Brightness brightnessIncremented should invalidete timer on error")
    }
}
