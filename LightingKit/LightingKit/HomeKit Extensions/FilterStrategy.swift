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
    associatedtype HomeKitObjectType: HomeKitObject
    associatedtype LightingKitObjectType: LightingKitObject
    func include(object: HomeKitObjectType, compareWith lightingKitObject: LightingKitObjectType) -> Bool
}

internal final class HomesByRoomStrategy: FilterStrategy {
    typealias HomeKitObjectType = HMHome
    typealias LightingKitObjectType = Room
    func include(object: HomeKitObjectType, compareWith lightingKitObject: LightingKitObjectType) -> Bool {
        return object.rooms.contains { lightingKitObject == $0 }
    }
}

internal final class LightbulbsByRoomStrategy: FilterStrategy {
    typealias HomeKitObjectType = HMAccessory
    typealias LightingKitObjectType = Room
    func include(object: HMAccessory, compareWith lightingKitObject: LightingKitObjectType) -> Bool {
        guard let room = object.room else { return false }
        return object.services.contains { $0.serviceType == HMServiceTypeLightbulb }
        && lightingKitObject == room
    }
}
