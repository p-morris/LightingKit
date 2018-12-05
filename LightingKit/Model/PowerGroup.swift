//
//  PowerGroup.swift
//  LightingKit
//
//  Created by Peter Morris on 05/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import HomeKit

/// Used to specify the characteristics of a group of like services belonging to different lights.
protocol CharacteristicGroup {
    associatedtype CharacteristicType: Characteristic
    var services: [CharacteristicType] { get }
    init?(services: [CharacteristicType])
}

/// Represents a group of power state services for grouped lights.
public struct PowerGroup: CharacteristicGroup {
    typealias CharacteristicType = Power
    /// The power services of the group
    let services: [Power]
    /**
     Initializes a `PowerGroup` object.
     - Parameters:
     - services: The power services for the group.
     - returns: An initialized `PowerGroup` object if `services` contains at least one service,
     nil otherwise.
     */
    init?(services: [Power]) {
        guard services.count > 0 else { return nil }
        self.services = services
    }
}
