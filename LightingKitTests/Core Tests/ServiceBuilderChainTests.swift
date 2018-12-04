//
//  ServiceBuilderChainTests.swift
//  LightingKitTests
//
//  Created by Peter Morris on 04/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
import HomeKit
@testable import LightingKit

class TestServicesBuilderChain: XCTestCase {
    func testPowerServiceHandlerAssignsPower() {
        let handler = PowerServiceHandler()
        let light = Light(name: "Test Light", uuid: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!)
        let mockPowerCharacteristic = MockCharacteristic()
        handler.assignService(to: light, with: mockPowerCharacteristic, successor: nil)
        XCTAssertNotNil(light.power, "PowerServiceHandler should assign power to light for valid characteristic.")
    }
    func testPowerServiceHandlerDoesNotAssignPowerForInvalidCharacteristic() {
        let handler = PowerServiceHandler()
        let light = Light(name: "Test Light", uuid: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!)
        let mockPowerCharacteristic = MockCharacteristic()
        mockPowerCharacteristic.characteristicType = HMCharacteristicTypeBrightness
        handler.assignService(to: light, with: mockPowerCharacteristic, successor: nil)
        XCTAssertNil(light.power, "PowerServiceHandler should not assign power to light for invalid characteristic.")
    }
    func testPowerServiceHandlerCallsSuccessorWhenCharacteristicIsNotHandled() {
        let handler = PowerServiceHandler()
        let light = Light(name: "Test Light", uuid: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!)
        let mockPowerCharacteristic = MockCharacteristic()
        mockPowerCharacteristic.characteristicType = HMCharacteristicTypeBrightness
        let mockHandler = MockServiceHandler()
        handler.assignService(to: light, with: mockPowerCharacteristic, successor: mockHandler)
        XCTAssertTrue(mockHandler.wasCalled, "PowerServiceHandler should call successor when characteristic is not handled.")
    }
    func testPowerServiceHandlerDoesntCallSuccessorWhenCharacteristicIsHandler() {
        let handler = PowerServiceHandler()
        let light = Light(name: "Test Light", uuid: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!)
        let mockPowerCharacteristic = MockCharacteristic()
        let mockHandler = MockServiceHandler()
        handler.assignService(to: light, with: mockPowerCharacteristic, successor: mockHandler)
        XCTAssertFalse(mockHandler.wasCalled, "PowerServiceHandler should not call successor when characteristic is handled.")
    }
    func testBrightnessServiceHandlerAssignsBrightness() {
        let handler = BrightnessServiceHandler()
        let light = Light(name: "Test Light", uuid: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!)
        let mockBrightnessCharacteristic = MockCharacteristic()
        mockBrightnessCharacteristic.characteristicType = HMCharacteristicTypeBrightness
        handler.assignService(to: light, with: mockBrightnessCharacteristic, successor: nil)
        XCTAssertNotNil(light.brightness, "BrightnessServiceHandler should assign brightness to light for valid characteristic.")
    }
    func testBrightnessServiceHandlerDoesNotAssignPowerForInvalidCharacteristic() {
        let handler = BrightnessServiceHandler()
        let light = Light(name: "Test Light", uuid: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!)
        let mockPowerCharacteristic = MockCharacteristic()
        handler.assignService(to: light, with: mockPowerCharacteristic, successor: nil)
        XCTAssertNil(light.power, "BrightnessServiceHandler should not assign brightness to light for invalid characteristic.")
    }
    func testBrightnessServiceHandlerCallsSuccessorWhenCharacteristicIsNotHandled() {
        let handler = BrightnessServiceHandler()
        let light = Light(name: "Test Light", uuid: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!)
        let mockPowerCharacteristic = MockCharacteristic()
        let mockHandler = MockServiceHandler()
        handler.assignService(to: light, with: mockPowerCharacteristic, successor: mockHandler)
        XCTAssertTrue(mockHandler.wasCalled, "BrightnessServiceHandler should call successor when characteristic is not handled.")
    }
    func testBrightnessServiceHandlerDoesntCallSuccessorWhenCharacteristicIsHandler() {
        let handler = BrightnessServiceHandler()
        let light = Light(name: "Test Light", uuid: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!)
        let mockBrightnessCharacteristic = MockCharacteristic()
        mockBrightnessCharacteristic.characteristicType = HMCharacteristicTypeBrightness
        let mockHandler = MockServiceHandler()
        handler.assignService(to: light, with: mockBrightnessCharacteristic, successor: mockHandler)
        XCTAssertFalse(mockHandler.wasCalled, "BrightnessServiceHandler should not call successor when characteristic is handled.")
    }
    func testLightServiceBuilderDoesntCallHandlersWhenCharacteristicsAreNil() {
        let mockhandler = MockServiceHandler()
        let builder = LightServiceBuilder(handlers: [mockhandler])
        let light = Light(name: "Test Light", uuid: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!)
        builder.assignServices(to: light, with: nil)
        XCTAssertFalse(mockhandler.wasCalled, "LightServiceBuilder should not use handlers when characteristics are nil")
    }
    func testLightServiceBuilderCorrectlyChainsHandlers() {
        let mockHandler1 = MockServiceHandler()
        let mockHandler2 = MockServiceHandler()
        let mockHandler3 = MockServiceHandler()
        let light = Light(name: "Test Light", uuid: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!)
        let builder = LightServiceBuilder(handlers: [mockHandler1, mockHandler2, mockHandler3])
        builder.assignServices(to: light, with: [MockCharacteristic()])
        XCTAssert(mockHandler1.wasCalled && mockHandler2.wasCalled && mockHandler3.wasCalled)
    }
}
