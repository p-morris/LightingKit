//
//  MockAccessoryBrowser.swift
//  LightingKitTests
//
//  Created by Peter Morris on 23/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit
@testable import LightingKit

class MockAccessoryBrowser: HomeKitAccessoryBrowserProtocol {
    var delegate: HMAccessoryBrowserDelegate?
    var stopped = false
    var started = false
    
    func stopSearchingForNewAccessories() {
        stopped = true
    }
    
    func startSearchingForNewAccessories() {
        started = true
    }
    
}
