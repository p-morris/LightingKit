//
//  MockBrightnessDelegate.swift
//  LightingKitTests
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit
@testable import LightingKit

class MockBrightnessDelegate: TimedBrightnessUpdateDelegate {
    var didChange = false
    var didComplete = false
    var updateFailed = false
    func brightness(_ brightness: Brightness, valueDidChange newValue: Int) {
        didChange = true
    }
    func brightness(_ brightness: Brightness, didCompleteTimedUpdate newValue: Int) {
        didComplete = true
    }
    func brightness(_ brightness: Brightness, timedUpdateFailed error: Error?) {
        updateFailed = true
    }
}
