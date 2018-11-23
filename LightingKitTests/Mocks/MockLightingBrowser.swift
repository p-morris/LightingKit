//
//  MockLightingBrowser.swift
//  LightingKitTests
//
//  Created by Peter Morris on 23/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit
@testable import LightingKit

class MockLightingBrowser: LightingKitBrowser {
    var newAccessories: [HMAccessory] = []
    var started = false
    func findNewLights(completion: @escaping (HMAccessory) -> Void) {
        started = true
    }
    var stopped = false
    func stop() {
        stopped = true
    }
    
    
}
