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

internal class HomesByRoomStrategy: FilterStrategy {
    typealias HomeKitObjectType = HMHome
    typealias LightingKitObjectType = Room
    func include(object: HMHome, compareWith lightingKitObject: Room) -> Bool {
        return true
    }
}

internal class LightbulbsByRoomStrategy: FilterStrategy {
    typealias HomeKitObjectType = HMAccessory
    typealias LightingKitObjectType = Room
    func include(object: HMAccessory, compareWith lightingKitObject: Room) -> Bool {
        return object.services.contains { $0.serviceType == HMServiceTypeLightbulb }
        && object.room != nil
        && lightingKitObject == object.room! // Safe - checked for nil first
    }
}
