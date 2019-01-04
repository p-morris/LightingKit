//
//  HomeArrayExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 05/12/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// Used to add utility functions to arrays of `HMHome` objects
internal extension Array where Element: HMHome {
    /**
     Returns  the `HMHome` object required associated with a given bridge.
     - Parameters:
     - bridge: The `Bridge` to find the home for.
     - Returns: An `HMHome` object if one is found. Nil otherwise
     */
    func home(for bridge: Bridge) -> HMHome? {
        return filter {
            return $0.accessories.contains(where: { bridge == $0 })
            }.first
    }
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
        guard let home = filter({ home == $0 }).first else { return [] }
        var rooms: [Room] = [home.roomForEntireHome().lightingKitObject()]
        rooms.append(contentsOf: home.rooms.lightingKitObjects())
        return rooms
    }
    /**
     Returns all the `Light` objects associated with a given `Home`.
     - Parameters:
     - home: The `Home` which the lights should be associated with.
     - Returns: An array of `Light` objects associated with `home`.
     */
    func lightingKitLights(for home: Home) -> [Light] {
        guard let home = filter({ home == $0 }).first else { return [] }
        return home.accessories.filter({ $0.isLighting }).lightingKitLights()
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
    /**
     Returns all the `Light` objects associated with a given `Bridge`.
     - Parameters:
     - bridge: The `Bridge` which the lights should be associated with.
     - Returns: An array of `Light` objects associated with `bridge`
     */
    func lightingKitLights(for bridge: Bridge) -> [Light] {
        guard let home = home(for: bridge) else { return [] }
        guard let bridge = home.accessories.filter({ bridge == $0 }).first else { return [] }
        return home.accessories.filter({
            $0.isLighting &&
                bridge.uniqueIdentifiersForBridgedAccessories?.contains($0.uniqueIdentifier) ?? false
        }).lightingKitLights()
    }
    func lightingKitGroups(for room: Room) -> [LightingGroup]? {
        guard let home = home(for: room) else { return nil }
        return home.serviceGroups.lightingGroups(for: room)
    }
}
