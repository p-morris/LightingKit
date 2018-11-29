//
//  TestLightinKit.swift
//  LightingKitTests
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
@testable import LightingKit

class TestLightingKit: XCTestCase {
    func testConfigureRequestsPermission() {
        let mockPermission = MockPermission()
        let lightingKit = LightingKit()
        lightingKit.configure(permission: mockPermission, manager: MockHomeManager())
        XCTAssertTrue(mockPermission.requested, "LightingKit configure should request permission via permission object.")
    }
    func testConfigureResetsDelegateOnSuccess() {
        let mockPermission = MockPermission()
        let lightingKit = LightingKit()
        let manager = MockHomeManager()
        lightingKit.configure(permission: mockPermission, manager: manager)
        XCTAssertNotNil(
            manager.delegate as? LightingKit,
            "LightingKit configure should set itself as manager delegate on successful initialization."
        )
    }
    func testConfigureSetsNilDelegateOnFailure() {
        let mockPermission = MockPermission()
        mockPermission.success = false
        let lightingKit = LightingKit()
        let manager = MockHomeManager()
        lightingKit.configure(permission: mockPermission, manager: manager)
        XCTAssertNil(manager.delegate, "LightingKit configure should set itself as manager delegate on successful initialization.")
    }
    func testReadyReturnsFalseWhenNotReady() {
        let mockPermission = MockPermission()
        mockPermission.success = false
        let lightingKit = LightingKit()
        let manager = MockHomeManager()
        lightingKit.configure(permission: mockPermission, manager: manager)
        XCTAssertFalse(lightingKit.ready, "LightingKit ready should return false when HomeKit not ready.")
    }
    func testReadyReturnsTrueWhenReady() {
        let mockPermission = MockPermission()
        mockPermission.success = true
        let lightingKit = LightingKit()
        let manager = MockHomeManager()
        lightingKit.configure(permission: mockPermission, manager: manager)
        XCTAssertTrue(lightingKit.ready, "LightingKit ready should return true when HomeKit is ready.")
    }
    func testHomesReturnsEmptyArrayWhenNotReady() {
        let mockPermission = MockPermission()
        mockPermission.success = false
        let lightingKit = LightingKit()
        let manager = MockHomeManager()
        lightingKit.configure(permission: mockPermission, manager: manager)
        XCTAssertEqual(lightingKit.homes.count, 0, "LightingKit homes should return empty array when not ready.")
        
    }
    func testRoomsReturnsEmptyArrayWhenNotReady() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let mockPermission = MockPermission()
        mockPermission.success = false
        let lightingKit = LightingKit()
        let manager = MockHomeManager()
        lightingKit.configure(permission: mockPermission, manager: manager)
        let home = Home(name: "", id: uuid)
        XCTAssertEqual(lightingKit.rooms(forHome: home).count, 0, "LightingKit rooms(home:) should return empty array when not ready.")
    }
    func testLightsReturnsEmptyArrayWhenNotReady() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let mockPermission = MockPermission()
        mockPermission.success = false
        let lightingKit = LightingKit()
        let manager = MockHomeManager()
        lightingKit.configure(permission: mockPermission, manager: manager)
        let room = Room(name: "", id: uuid)
        XCTAssertEqual(lightingKit.lights(forRoom: room).count, 0, "LightingKit lights(room:) should return empty array when not ready.")
    }
    func testConfigureHomeKitNotifiesDelegateWhenAlreadyConfigured() {
        let lightingKit = LightingKit()
        let mockDelegate = MockLightingKitDelegate()
        let mockPermission = MockPermission()
        mockPermission.success = true
        let mockManager = MockHomeManager()
        lightingKit.configure(permission: mockPermission, manager: mockManager)
        lightingKit.permissionsDelegate = mockDelegate
        lightingKit.start()
        XCTAssertTrue(mockDelegate.configured, "LightingKit configureHomeKit should notify delegate if already configured.")
    }
    func testAddHomeUsesHomeManagerAddHome() {
        let lightingKit = LightingKit()
        let mockPermission = MockPermission()
        mockPermission.success = true
        let mockManager = MockHomeManager()
        lightingKit.configure(permission: mockPermission, manager: mockManager)
        lightingKit.addHome(name: "Hello") { _ in }
        XCTAssertTrue(mockManager.addedHome, "LightingKit addHome should invoke home manager addHome function.")
    }
    func testAddHomeExecutesCompletion() {
        let lightingKit = LightingKit()
        let mockPermission = MockPermission()
        mockPermission.success = true
        let mockManager = MockHomeManager()
        lightingKit.configure(permission: mockPermission, manager: mockManager)
        let completion = MockAddHomeCompletion()
        lightingKit.addHome(name: "Hello", completion: completion.completion)
        XCTAssertTrue(completion.called, "LightingKit addHome should execute completion.")
    }
    func testStopSearchCallsBrowserStop() {
        let mockBrowser = MockLightingBrowser()
        let lightingKit = LightingKit(browser: mockBrowser)
        lightingKit.findNewLights()
        lightingKit.stopNewLightingSearch()
        XCTAssertTrue(mockBrowser.stopped, "LightingKit stopNewLightingSearch should stop browser from searching.")
    }
    func testFindNewLightsStartsBrowser() {
        let mockBrowser = MockLightingBrowser()
        let lightingKit = LightingKit(browser: mockBrowser)
        lightingKit.findNewLights()
        XCTAssertTrue(mockBrowser.started, "LightingKit startNewLightingSearch should start browser.")
    }
}
