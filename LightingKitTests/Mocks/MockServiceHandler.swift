//
//  MockServiceHandler.swift
//  LightingKitTests
//
//  Created by Peter Morris on 04/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit
@testable import LightingKit

class MockServiceHandler: ServiceHandler {
    var wasCalled = false
    var successorWasNil = true
    func assignService(to light: Light, with characteristic: HomeKitCharacteristicProtocol?, successor: ServiceHandler?) {
        wasCalled = true
        successorWasNil = successor == nil
    }
}
