//
//  FoundationExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation

protocol TimerProtocol {
    static func scheduledTimer(timeInterval ti: TimeInterval, target aTarget: Any, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool) -> Timer
    func invalidate()
}

extension Timer: TimerProtocol { }
