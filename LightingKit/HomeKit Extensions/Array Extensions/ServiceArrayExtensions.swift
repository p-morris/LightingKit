//
//  ServiceArrayExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 05/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// Used to add computer property to support easy access to light bulb services.
internal extension Array where Element: HMService {
    /// The lightbulb service if one exists, or `nil` otherwise.
    var light: HMService? {
        return filter { $0.serviceType == HMServiceTypeLightbulb }.first
    }
    /**
     Returns an array `Characteristic` objects associated with each element's `characteristics` array.
     - Returns: An array of `Characteristic` objects.
     */
    func lightingKitCharacteristics<T>() -> [T] where T: Characteristic {
        var characteristics: [T] = []
        forEach { characteristics.append(contentsOf: $0.characteristics.lightingKitCharacteristics()) }
        return characteristics
    }
}

/// Used to add functions used for mapping `HMServiceGroup` objects to `LightingGroup` objects.
internal extension Array where Element: HMServiceGroup {
    /**
     Returns all the `LightingGroup` objects associated with a given `Room`.
     - Parameters:
     - room: The `Room` which the groups should be associated with.
     - factory: The `GroupFactory` to use for creating `LightingGroup` objects.
     - Returns: An array of `LightingGroup` objects associated with `room`.
     */
    func lightingGroups(for room: Room, factory: GroupFactory = LightingGroupFactory()) -> [LightingGroup] {
        let lightingKitGroups = lightingServices(for: room).compactMap { (group) -> LightingGroup? in
            return factory.build(
                name: group.name,
                uuid: group.uniqueIdentifier,
                powerArray: group.services.lightingKitCharacteristics(),
                brightnessArray: group.services.lightingKitCharacteristics()
            )
        }
        return lightingKitGroups
    }
    /**
     Returns all the `HMServiceGroup` objects associated with a given `Room`.
     - Parameters:
     - room: The `Room` which the groups should be associated with.
     - Returns: An array of `HMServiceGroup` objects associated with `room`.
     */
    func lightingServices(for room: Room) -> [HMServiceGroup] {
        return filter {
            $0.services.filter { service -> Bool in
                guard let accessoryRoom = service.accessory?.room else { return false }
                return service.isLighting && room == accessoryRoom
            }.count > 0
        }
    }
}
