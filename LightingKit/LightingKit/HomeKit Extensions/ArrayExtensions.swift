//
//  ArrayExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 21/11/2018.
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
            let lightingKitObject = T.init(name: object.name, id: object.uniqueIdentifier)
            array.append(lightingKitObject)
        }
        return array
    }
}

/// Used to add utility functions to arrays of `HMHome` objects
internal extension Array where Element: HMHome {
    /**
     Returns  the `HMHome` object required by the filtering strategy passed in.
     - Parameters:
     - room: The `Room` which belongs to the home to find.
     - strategy: The `HomesByRoomStrategy` to determine whether the home is matched.
     - Returns: An `HMHome` object if one is found. Nil otherwise
     */
    func home(for room: Room, strategy: HomesByRoomStrategy = HomesByRoomStrategy()) -> HMHome? {
        return self.filter({ return strategy.include(object: $0, compareWith: room) }).first
    }
    /**
     Returns all the `Room` objects associated with a given `Home`.
     - Parameters:
     - home: The `Home` which the rooms should be associated with.
     - Returns: An array of `Room` objects associated with `home`.
     */
    func rooms(for home: Home) -> [Room] {
        return filter({ home == $0 }).first?.rooms.lightingKitObjects() ?? []
    }
    /**
     Returns all the `Light` objects associated with a given `Room`.
     - Parameters:
     - room: The `Room` which the lights should be associated with.
     - Returns: An array of `Light` objects associated with `room`
     */
    func lightingKitLights(for room: Room) -> [Light] {
        guard let home = home(for: room) else { return [] }
        return home.accessories.lightingKitLights(for: room)
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
        return lightBulbAccessories(for: room).lightingKitObjects()
    }
}
