//
//  Int+SanitizeBrightness.swift
//  LightingKit
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation

extension Int {
    func sanitizedBrightness() -> Int {
        // Brightness must be >= 0 && <= 100.
        return (self < 0 ? 0 : (self > 100 ? 100 : self))
    }
}
