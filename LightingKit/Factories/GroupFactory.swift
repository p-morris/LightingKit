//
//  GroupBuilder.swift
//  LightingKit
//
//  Created by Peter Morris on 05/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

protocol GroupFactory {
    func build(name: String, uuid: UUID, powerArray: [Power], brightnessArray: [Brightness]) -> LightingGroup?
}

class LightingGroupFactory: GroupFactory {
    func build(name: String, uuid: UUID, powerArray: [Power], brightnessArray: [Brightness]) -> LightingGroup? {
        guard let power = PowerGroup(services: powerArray) else { return nil }
        let brightness = BrightnessGroup(services: brightnessArray)
        return LightingGroup(name: name, uuid: uuid, powerGroup: power, brightnessGroup: brightness)
    }
}
