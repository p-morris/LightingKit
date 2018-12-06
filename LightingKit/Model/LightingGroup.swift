//
//  LightingGroup.swift
//  LightingKit
//
//  Created by Peter Morris on 05/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import HomeKit

/// Represents a grouping of lights, along with their services such as power and brightness
public struct LightingGroup {
    /// The name of the group
    let name: String
    /// The unique identifier of the group
    let uuid: UUID
    /// The power services for the group
    let power: PowerGroup
    /// The brightness services for the group
    let brightness: BrightnessGroup?
    /**
     Initializes a `LightingGroup` object.
     - Parameters:
     - name: The name of the group.
     - uuid: The unique identifier for the group.
     - powerGroup: The power services for the group
     - brightnessGroup: The brightness services for the group
     - returns: An initialized `LightingGroup` object.
     */
    init(name: String, uuid: UUID, powerGroup: PowerGroup, brightnessGroup: BrightnessGroup?) {
        self.name = name
        self.uuid = uuid
        self.power = powerGroup
        self.brightness = brightnessGroup
    }
}
