//
//  BrightnessGroup.swift
//  LightingKit
//
//  Created by Peter Morris on 05/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation

/// Represents a group of brightness services for grouped lights.
public struct BrightnessGroup: CharacteristicGroup {
    typealias CharacteristicType = Brightness
    /// The brightness services of the group
    let services: [Brightness]
    /**
     Initializes a `BrightnessGroup` object.
     - Parameters:
     - services: The brightness services for the group.
     - returns: An initialized `BrightnessGroup` object if `services` contains at least one service,
     nil otherwise.
     */
    init?(services: [Brightness]) {
        guard services.count > 0 else { return nil }
        self.services = services
    }
}
