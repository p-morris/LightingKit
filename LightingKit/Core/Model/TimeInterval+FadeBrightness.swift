//
//  TimeInterval+FadeBrightness.swift
//  LightingKit
//
//  Created by Peter Morris on 23/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation

extension TimeInterval {
    /**
     Calculates the `TimeInterval` required to for each incremental brightness update,
     to increment from `currentBrightness` to `targetBrightness` over the duration of `self`.
     - Parameters:
     - currentBrightness: The current brightness value. 0-100.
     - targetBrightness: The target brightness value. 0-100.
     */
    func incrementInterval(currentBrightness: Int, targetBrightness: Int) -> TimeInterval {
        let target = targetBrightness, current = currentBrightness
        let difference = target > current ?
                         target - current :
                         current - target
        return self / TimeInterval(difference)
    }
}
