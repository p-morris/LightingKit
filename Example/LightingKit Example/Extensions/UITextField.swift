//
//  UITextField.swift
//  LightingKit Example
//
//  Created by Peter Morris on 28/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import UIKit

extension UITextField {
    func intFromText() -> Int? {
        guard let text = text else { return nil }
        guard let integerValue = Int(text) else { return nil }
        return integerValue
    }
    func timeIntervalFromText() -> TimeInterval? {
        guard let integerValue = intFromText() else { return nil }
        return TimeInterval(integerValue)
    }
}
