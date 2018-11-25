//
//  MockTimer.swift
//  LightingKitTests
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
@testable import LightingKit

class MockTimer: Timer {
    static var wasScheduled = false
    static var wasInvalidated = false
    override static func scheduledTimer(timeInterval ti: TimeInterval, target aTarget: Any, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool) -> Timer {
        wasScheduled = true
        return MockTimer()
    }
    
    override func invalidate() {
        MockTimer.wasInvalidated = true
    }
    
    
}
