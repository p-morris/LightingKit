//
//  FilterStrategy.swift
//  LightingKit
//
//  Created by Peter Morris on 21/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

internal protocol FilterStrategy {
    associatedtype HomeKitObjectType: HomeKitObjectProtocol
    func include(object: HomeKitObjectType, compareWith room: Room) -> Bool
}

/// Used to determine whether an `HMHome` object should be included in a filtered array.
internal class HomesByRoomStrategy: FilterStrategy {
    typealias HomeKitObjectType = HMHome
    /**
     Used to determine whether a give `HMHome` object should be included in a filtered array.
     An object is included when one the `HMRoom` objects contained in its `rooms` array has a `UUID`
     which matches a given `Room` object.
     - Parameters:
     - object: The `HMHome` object that may be included in a filtered array.
     - room: The `Room` object that should be associated with `object` if it is to be included.
     - Returns: `true` if the `HMHome` should be included in the filtered array, false otherwise.
     */
    func include(object: HomeKitObjectType, compareWith room: Room) -> Bool {
        return object.rooms.contains { room == $0 }
    }
}

/// Used to determine whether an `HMAccessory` object should be included in a filtered array.
internal class LightbulbsByRoomStrategy: FilterStrategy {
    typealias HomeKitObjectType = HMAccessory
    /**
     Used to determine whether a give `HMAccessory` object should be included in a filtered array.
     An accessory is included when its `services` array contains a service whose `serviceType` is `HMServiceTypeLightbulb`,
     and the accessories `room` is equal to the the `Room` passed in.
     - Parameters:
     - object: The `HMAccessory` object that may be included in a filtered array.
     - room: The `Room` object that should be associated with `object` if it is to be included.
     - Returns: `true` if the `HMAccessory` should be included in the filtered array, false otherwise.
     */
    func include(object: HomeKitObjectType, compareWith room: Room) -> Bool {
        guard let homeKitRoom = object.room else { return false }
        return object.category.isLighting && room == homeKitRoom
    }
}
