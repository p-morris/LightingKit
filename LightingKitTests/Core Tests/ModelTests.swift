//
//  TestModelEquatable.swift
//  LightingKitTests
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import XCTest
@testable import LightingKit

class TestModelEquatable: XCTestCase {
    func testHomeEquals() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let home1 = Home(name: "Test", id: uuid)
        let home2 = MockHomeKitObject(uniqueIdentifier: uuid, name: "Test")
        XCTAssertTrue(home1 == home2, "Home equatable should return true for HMHome with equal UUID.")
    }
    func testHomeNotEqual() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let uuid2 = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5E")!
        let home1 = Home(name: "Test", id: uuid)
        let home2 = MockHomeKitObject(uniqueIdentifier: uuid2, name: "Test")
        XCTAssertFalse(home1 == home2, "Home equatable should return false for HMHome with inequal UUID.")
    }
    func testRoomEqual() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let room1 = Room(name: "Test", id: uuid)
        let room2 = MockHomeKitObject(uniqueIdentifier: uuid, name: "Test")
        XCTAssertTrue(room1 == room2, "Room equatable should return true for HMRoom with equal UUID.")
    }
    func testRoomNotEqual() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let uuid2 = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5E")!
        let room1 = Room(name: "Test", id: uuid)
        let room2 = MockHomeKitObject(uniqueIdentifier: uuid2, name: "Test")
        XCTAssertFalse(room1 == room2, "Room equatable should return false for HMRoom with equal UUID.")
    }
    func testLightEqual() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let light1 = Light(name: "Test", id: uuid)
        let light2 = Light(name: "Test2", id: uuid)
        XCTAssertEqual(light1, light2, "Light equatable should return true for equal light.")
    }
    func testLightNotEqual() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let uuid2 = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5E")!
        let light1 = Light(name: "Test", id: uuid)
        let light2 = Light(name: "Test2", id: uuid2)
        XCTAssertNotEqual(light1, light2, "Light equatable should return false for non-equal light.")
    }
    func testLightEqualToHomeKitObject() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let light = Light(name: "Test", id: uuid)
        let light2 = MockHomeKitObject(uniqueIdentifier: uuid, name: "Test")
        XCTAssert(light == light2, "Light equatable should return true for equal home kit light.")
    }
    func testLightNotEqualToHomeKitObject() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let uuid2 = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5E")!
        let light = Light(name: "Test", id: uuid)
        let light2 = MockHomeKitObject(uniqueIdentifier: uuid2, name: "Test")
        XCTAssertFalse(light == light2, "Light equatable should return false for non-equal home kit light.")
    }
}
