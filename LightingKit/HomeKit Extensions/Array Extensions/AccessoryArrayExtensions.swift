//
//  AccessoryArrayExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 05/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// Used to extend array to map HomeKit objects to concrete `LightingKitObject` instances.
internal extension Array where Element: HomeKitObjectProtocol {
    /**
     Initializes and returns LightingKit representations of the HomeKit object elements.
     - Returns: An array of LightingKit objects representing the HomeKit objects contained in
     the array.
     */
    func lightingKitObjects<T: LightingKitObject>() -> [T] {
        var array: [T] = []
        forEach { object in
            array.append(object.lightingKitObject())
        }
        return array
    }
}

/// Used to extend array to map HomeKit accessories with LightBulb services on `Light` instances.
internal extension Array where Element: HomeKitAccessoryProtocol {
    /**
     Initializes and returns `Light` representations of the HomeKit accessories with Lightbulb services..
     - Returns: An array of `Light` objects representing the HomeKit accessories contained in
     the array.
     */
    func lightingKitLights(servicesBuilder builder: HomeKitServiceBuilder
        = LightServiceFactory(handlers: [PowerServiceHandler(), BrightnessServiceHandler()]))
        -> [Light] {
            var lights: [Light] = []
            forEach { object in
                let light: Light = object.lightingKitObject()
                builder.assignServices(to: light, with: object.services.light?.characteristics)
                lights.append(light)
            }
            return lights
    }
}

internal extension Array where Element: HMAccessory {
    /**
     Returns all the `HMAccessory` objects required by the fitering strategy passed in.
     - Parameters:
     - room: The `Room` which belongs to the home to find.
     - strategy: The `LighbulbsByRoomStrategy` to determine whether to include an accessory.
     - Returns: An array of `HMAccessory` objects.
     */
    func lightBulbAccessories(for room: Room,
                              strategy: LightbulbsByRoomStrategy = LightbulbsByRoomStrategy())
        -> [HMAccessory] {
            return filter { strategy.include(object: $0, compareWith: room) }
    }
    /**
     Returns all the `Light` objects associated with a given `Room`.
     - Parameters:
     - room: The `Room` which the lights should be associated with.
     - Returns: An array of `Light` objects associated with `room`
     */
    func lightingKitLights(for room: Room) -> [Light] {
        return lightBulbAccessories(for: room).lightingKitLights()
    }
}
