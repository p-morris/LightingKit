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
        let home2 = MockHomeKitHome(uniqueIdentifier: uuid, name: "Test")
        XCTAssertTrue(home1 == home2, "Home equatable should return true for HMHome with equal UUID.")
    }
    func testHomeNotEqual() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let uuid2 = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5E")!
        let home1 = Home(name: "Test", id: uuid)
        let home2 = MockHomeKitHome(uniqueIdentifier: uuid2, name: "Test")
        XCTAssertFalse(home1 == home2, "Home equatable should return false for HMHome with inequal UUID.")
    }
    func testRoomEqual() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let room1 = Room(name: "Test", id: uuid)
        let room2 = MockHomeKitHome(uniqueIdentifier: uuid, name: "Test")
        XCTAssertTrue(room1 == room2, "Room equatable should return true for HMRoom with equal UUID.")
    }
    func testRoomNotEqual() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let uuid2 = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5E")!
        let room1 = Room(name: "Test", id: uuid)
        let room2 = MockHomeKitHome(uniqueIdentifier: uuid2, name: "Test")
        XCTAssertFalse(room1 == room2, "Room equatable should return false for HMRoom with equal UUID.")
    }
}
