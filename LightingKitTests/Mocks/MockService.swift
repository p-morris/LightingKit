//
//  MockService.swift
//  LightingKitTests
//
//  Created by Peter Morris on 04/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit
@testable import LightingKit

class MockService: HomeKitServiceProtocol {
    var testType: String = HMServiceTypeFan
    var serviceType: String {
        return testType
    }
}
