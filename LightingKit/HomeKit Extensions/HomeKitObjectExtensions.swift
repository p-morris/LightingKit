//
//  HomeKitObjectExtensions.swift
//  LightingKit
//
//  Created by Peter Morris on 25/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// An abstraction for HomeKit objects
internal protocol HomeKitObjectProtocol {
    var name: String { get }
    var uniqueIdentifier: UUID { get }
}

/// Used to bridge HomeKit objects to LightningKit structs
extension HomeKitObjectProtocol {
    /**
     Returns a `LightingKitObject` representing the current HomeKit object.
     - Parameters:
     - Returns: An initialized instance of a concrete `LightingKitObject` class.
     */
    func lightingKitObject<T: LightingKitObject>() -> T {
        return T.init(name: self.name, id: self.uniqueIdentifier)
    }
}

/// An abstraction for HomeKit Accessories
protocol HomeKitAccessoryProtocol: HomeKitObjectProtocol {
    var services: [HMService] { get }
}

extension HMHome: HomeKitObjectProtocol { }
extension HMRoom: HomeKitObjectProtocol { }
extension HMAccessory: HomeKitAccessoryProtocol { }
