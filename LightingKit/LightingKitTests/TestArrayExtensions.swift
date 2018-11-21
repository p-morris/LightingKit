//
//  TestArrayExtensions.swift
//  LightingKitTests
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import XCTest
@testable import LightingKit

class ArrayExtensionTests: XCTestCase {
    func testGenericInitialization() {
        let mockHomeKitHome = MockHomeKitHome(uniqueIdentifier: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!, name: "TestHome")
        let mockHomeKitHome2 = MockHomeKitHome(uniqueIdentifier: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5E")!, name: "TestHome")
        let lightingKitHomes: [MockLightingKitObject] = [mockHomeKitHome, mockHomeKitHome2].lightingKitObjects()
        XCTAssertEqual(lightingKitHomes.count, 2, "Array extension lightingKitObjects should return a Home object for each HMHome.")
    }
    func testGenericInitialzationUsesCorrectInitParams() {
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let mockHomeKitHome = MockHomeKitHome(uniqueIdentifier: uuid, name: "TestHome")
        let lightningKitHome: MockLightingKitObject? = [mockHomeKitHome].lightingKitObjects().first
        XCTAssert(lightningKitHome != nil &&
            lightningKitHome!.id == mockHomeKitHome.uniqueIdentifier &&
            lightningKitHome!.name == mockHomeKitHome.name,
            "Array extension lightinKitObjects should pass correct values for init params."
        )
    }
    
}
